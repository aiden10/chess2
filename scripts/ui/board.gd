extends Node2D

class_name Board

var tile_scene = preload("res://scenes/tile.tscn")
@export var board_margin: float = 50.0  # Margin from screen edges

# These will be calculated based on screen size
var tile_size: Vector2
var offset: Vector2

func initialize() -> void:
	# Connect to window resize signal
	get_tree().root.size_changed.connect(_on_window_resize)
	
	# Also redraw the board to show valid tiles
	EventBus.piece_selected.connect(draw_board)
	
	_calculate_tile_size()
	draw_board()
	
func _calculate_tile_size() -> void:
	# Get the visible screen size
	var screen_size = get_viewport_rect().size
	
	# Calculate tile size based on screen size and board dimensions
	# Subtract margins and divide by number of tiles
	var available_width = screen_size.x - (board_margin * 2)
	var available_height = screen_size.y - (board_margin * 2)
	
	# Calculate tile size to fit either width or height, whichever is smaller
	var width_based_size = available_width / BoardState.COLS
	var height_based_size = available_height / BoardState.ROWS
	var tile_dimension = min(width_based_size, height_based_size)
	
	tile_size = Vector2(tile_dimension, tile_dimension)
	offset = Vector2(tile_dimension, tile_dimension) * 1.05  # 5% gap between tiles
	
	# Center the board
	position.x = (screen_size.x - (offset.x * BoardState.COLS)) / 2
	position.y = (screen_size.y - (offset.y * BoardState.ROWS)) / 2

func draw_board() -> void:
	# Clear existing tiles
	for child in get_children():
		child.queue_free()
	var valid_movement_tiles: Array[Vector2i] 
	if GameState.selected_piece:
		valid_movement_tiles = GameState.selected_piece.can_move_to()
		
	for row in BoardState.board.size():
		for col in BoardState.board[row].size():
			var tile = tile_scene.instantiate()
			var color = Color.WHITE if (row + col) % 2 == 0 else Color.BLACK
			
			if GameState.selected_piece != null:
				if Vector2i(row, col) in valid_movement_tiles:
					color = Constants.VALID_MOVE_TILE_COLOR
			
			var piece: Piece = BoardState.board[row][col]
			var sprite = null
			if piece != null:
				sprite = piece.texture

			# Set tile properties
			tile.position = Vector2(col * offset.x, row * offset.y)
			tile.color = color
			tile.size = tile_size
			tile.row = row
			tile.col = col
			tile.sprite = sprite
			
			# Set up mouse detection
			var collision_shape = CollisionShape2D.new()
			var rectangle_shape = RectangleShape2D.new()
			rectangle_shape.size = tile_size
			collision_shape.shape = rectangle_shape
			collision_shape.position = tile_size / 2

			# Add Area2D for mouse detection
			var area = Area2D.new()
			area.position = Vector2.ZERO
			area.add_child(collision_shape)
			tile.add_child(area)
			
			# Connect mouse signals
			area.mouse_entered.connect(tile._on_mouse_entered)
			area.mouse_exited.connect(tile._on_mouse_exited)
			area.input_event.connect(tile._input_event)
			
			add_child(tile)

func _on_window_resize() -> void:
	_calculate_tile_size()
	draw_board()
