extends Node2D

@export var color: Color = Color.WHITE
@export var size: Vector2 = Vector2(Constants.TILE_SIZE, Constants.TILE_SIZE)  # Default tile size
@export var hover_color_offset: float = 0.2  # How much to brighten on hover

var is_hovered: bool = false
var last_color: Color
var row: int
var col: int

func _ready() -> void:
	last_color = color
	set_process_input(true)
	queue_redraw()

func _draw() -> void:
	# Draw a rectangle for the tile
	var rect = Rect2(Vector2.ZERO, size)
	draw_rect(rect, color)
	draw_rect(rect, Color.BLACK, false) # false means no fill, only outline
	
func _on_mouse_entered() -> void:
	is_hovered = true
	color = Color(last_color.r, last_color.g, last_color.b, 0.1)
	queue_redraw()

func _on_mouse_exited() -> void:
	is_hovered = false
	color = last_color
	queue_redraw()
	
# Optional: Add interaction handling
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_on_tile_clicked()

func _on_tile_clicked() -> void:
	# Handle tile click event
	print("Clicked: (", row, ", ", col, ")")
	# You can emit a signal here if you need to communicate with the board
