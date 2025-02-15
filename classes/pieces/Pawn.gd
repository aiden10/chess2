extends Piece

class_name Pawn
var reversed: bool = false

func _init(piece_color: PieceColor) -> void:
	super._init(PieceType.PAWN, piece_color)
	self.strength = Constants.PAWN_STRENGTH
	self.health = Constants.PAWN_HP
	self.max_health = Constants.PAWN_HP
	self.attack_range = Constants.PAWN_RANGE
	if piece_color == PieceColor.WHITE:
		self.texture = load("res://resources/sprites/white/pawn.png")
	else:
		self.texture = load("res://resources/sprites/black/pawn1.png")

func can_move_to() -> Array[Vector2i]:
	var valid_moves: Array[Vector2i] = []
	var direction = 1 if color == PieceColor.WHITE else -1
	if self.reversed:
		direction *= -1
		
	# Forward one space
	var forward = Vector2i(position.x + direction, position.y)
	if forward.x >= 0 and forward.x < 8 and BoardState.board[forward.x][forward.y] == null:
		valid_moves.append(forward)

	# Initial two space move
	if not has_moved:
		var double_forward = Vector2i(position.x + (2 * direction), position.y)
		if double_forward.x >= 0 and double_forward.x < 8 and BoardState.board[double_forward.x][double_forward.y] == null:
			valid_moves.append(double_forward)
			
	return valid_moves

func attack_targets() -> Array[Vector2i]:
	var valid_targets: Array[Vector2i] = []
	var direction = 1 if color == PieceColor.WHITE else -1
	if self.reversed:
		direction *= -1

	var moves: Array[Vector2i]
	moves = [
		Vector2i(direction, 1), Vector2i(direction, -1),
	]
	
	for move in moves:
		var new_pos = Vector2i(position.x + move.x, position.y + move.y)
		## Ignore out of bounds
		if new_pos.x < 0 or new_pos.x >= BoardState.COLS or new_pos.y < 0 or new_pos.y >= BoardState.COLS:
			continue
			
		var other_piece: Piece = BoardState.board[new_pos.x][new_pos.y]
		if other_piece:
			var x_diff: int = abs(position.x - new_pos.x)
			var y_diff: int = abs(position.y - new_pos.y)
			if (other_piece.color != color and x_diff <= attack_range and y_diff <= attack_range):
				valid_targets.append(new_pos)

	return valid_targets
	
