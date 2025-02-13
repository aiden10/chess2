extends Piece

class_name Bishop

func _init(piece_color: PieceColor) -> void:
	super._init(PieceType.BISHOP, piece_color)
	self.strength = Constants.BISHOP_STRENGTH
	self.health = Constants.BISHOP_HP
	self.max_health = Constants.BISHOP_HP
	self.attack_range = Constants.BISHOP_RANGE
	if piece_color == PieceColor.WHITE:
		self.texture = load("res://resources/sprites/white/bishop.png")
	else:
		self.texture = load("res://resources/sprites/black/bishop1.png")
		
func can_move_to() -> Array[Vector2i]:
	var directions = [
		Vector2i(1, 1),   # Up-right
		Vector2i(1, -1),  # Down-right 
		Vector2i(-1, 1),  # Up-left
		Vector2i(-1, -1)  # Down-left
	]
	var valid_moves: Array[Vector2i] = []
	# Diagonal moves in all directions
	for direction in directions:
		for i in range(1, BoardState.COLS):
			var pos = Vector2i(
				position.x + (direction.x * i),
				position.y + (direction.y * i)
			)
			
			# Check if position is out of bounds
			if pos.x < 0 or pos.x >= BoardState.COLS or pos.y < 0 or pos.y >= BoardState.COLS:
				continue  # Stop checking this direction if we're out of bounds
				
			# Check if there's a piece at this position
			if BoardState.board[pos.x][pos.y] != null:
				break # Stop checking this direction if a piece is in the way
				
			valid_moves.append(pos)
	
	return valid_moves

func attack_targets() -> Array[Vector2i]:
	var directions = [
		Vector2i(1, 1),   # Up-right
		Vector2i(1, -1),  # Down-right 
		Vector2i(-1, 1),  # Up-left
		Vector2i(-1, -1)  # Down-left
	]
	var valid_targets: Array[Vector2i] = []
	for direction in directions:
		for i in range(1, self.attack_range):
			var pos = Vector2i(
				position.x + (direction.x * i),
				position.y + (direction.y * i)
			)
			# Check if position is out of bounds
			if pos.x < 0 or pos.x >= BoardState.COLS or pos.y < 0 or pos.y >= BoardState.COLS:
				continue  # Stop checking this direction if we're out of bounds
			
			var other_piece: Piece = BoardState.board[pos.x][pos.y]

			if other_piece != null:
				var x_diff: int = abs(position.x - pos.x) 
				var y_diff: int = abs(position.y - pos.y) 
				if other_piece.color != color and x_diff <= attack_range and y_diff <= attack_range:
					valid_targets.append(pos)
					break # Stop checking this direction after a piece is reached
				
	return valid_targets
	
