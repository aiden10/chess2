extends Node2D

## How much more transparent to make the tile (color.a - hover_color_offset)
var hover_color_offset: float = Constants.HOVER_COLOR_ALPHA
var color: Color
var size: Vector2 = Vector2(Constants.TILE_SIZE, Constants.TILE_SIZE)  # Default tile size
var is_hovered: bool = false
var last_color: Color
var row: int
var col: int
var sprite: Texture2D
 
func _ready() -> void:
	last_color = color
	set_process_input(true)
	queue_redraw()

func set_size(new_size: Vector2) -> void:
	size = new_size
	queue_redraw()	

func _draw() -> void:
	# Draw a rectangle for the tile
	var rect = Rect2(Vector2.ZERO, size)
	draw_rect(rect, color)
	draw_rect(rect, Color.BLACK, false) # false means no fill, only outline
	if sprite:
		# Calculate position to center the sprite in the tile
		var sprite_rect = Rect2(Vector2.ZERO, sprite.get_size())
		# Scale sprite to fit within the tile while maintaining aspect ratio
		var scale = min(size.x / sprite.get_size().x, size.y / sprite.get_size().y)
		scale /= Constants.SPRITE_SIZE
		var scaled_size = sprite.get_size() * scale
		var pos = (size - scaled_size) / 2  # Center the sprite
		draw_texture_rect(sprite, Rect2(pos, scaled_size), false)

func _on_mouse_entered() -> void:
	is_hovered = true
	color = Color(last_color.r, last_color.g, last_color.b, 0.1)
	queue_redraw()

func _on_mouse_exited() -> void:
	is_hovered = false
	color = last_color
	queue_redraw()

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_on_tile_clicked()

## Updates selected piece and emits a signal to render the piece overlay
func _on_tile_clicked() -> void:
	var position: Piece = BoardState.board[row][col]
	if position == GameState.selected_piece:
		GameState.selected_piece = null
	## Move
	elif not position and GameState.selected_piece and GameState.selected_piece.color == GameState.turn:
		## Deselect piece if they select an empty tile that cannot be moved to 
		if Vector2i(row, col) not in GameState.selected_piece.can_move_to():
			GameState.selected_piece = null
		else:
			EventBus.move.emit(position, row, col)
	else:
		GameState.selected_piece = position
	
	EventBus.piece_selected.emit()
