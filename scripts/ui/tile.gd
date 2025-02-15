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

@onready var health_label: Label = $Panel/PieceHealth
@onready var panel: Panel = $Panel
@onready var area: Area2D = $Area
@onready var collision: CollisionShape2D = $Area/Collision

func _ready() -> void:
	var rectangle_shape = RectangleShape2D.new()
	rectangle_shape.size = size
	collision.shape = rectangle_shape
	collision.position = size / 2
	area.mouse_entered.connect(_on_mouse_entered)
	area.mouse_exited.connect(_on_mouse_exited)
	area.input_event.connect(_input_event)

	last_color = color
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
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
		# Scale sprite to fit within the tile while maintaining aspect ratio
		var scale_size = min(size.x / sprite.get_size().x, size.y / sprite.get_size().y)
		scale_size /= Constants.SPRITE_SIZE
		var scaled_size = sprite.get_size() * scale_size
		var pos = (size - scaled_size) / 2  # Center the sprite
		draw_texture_rect(sprite, Rect2(pos, scaled_size), false)
	
	var piece: Piece = BoardState.board[row][col]
	if piece:
		health_label.visible = true
		panel.visible = true
		health_label.text = str(piece.health) + "/" + str(piece.max_health)
	else:
		health_label.text = ""
		health_label.visible = false
		panel.visible = false
		
func _on_mouse_entered() -> void:
	color = Color(last_color.r, last_color.g, last_color.b, 0.1)
	EventBus.tile_entered.emit(BoardState.board[row][col], row, col)
	queue_redraw()

func _on_mouse_exited() -> void:
	color = last_color
	EventBus.tile_exited.emit()
	queue_redraw()

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_on_tile_clicked()

## Emits signals to update the UI and process the event
func _on_tile_clicked() -> void:
	EventBus.tile_clicked.emit(BoardState.board[row][col], row, col)
	EventBus.piece_selected.emit()
