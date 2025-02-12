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

## Emits signals to update the UI and process the event
func _on_tile_clicked() -> void:
	var other_piece: Piece = BoardState.board[row][col]
	EventBus.tile_clicked.emit(other_piece, row, col)
	EventBus.piece_selected.emit()
