extends Piece

class_name Knight

func _init(piece_color: PieceColor) -> void:
	super._init(PieceType.KNIGHT, piece_color)
	self.strength = Constants.KNIGHT_STRENGTH
	self.health = Constants.KNIGHT_HP
	self.max_hp = Constants.KNIGHT_HP
	self.passive = passive_ability
	self.primary = primary_ability
	self.ultimate = ultimate_ability
	if piece_color == PieceColor.WHITE:
		self.texture = load("res://resources/sprites/white/knight.png")
	else:
		self.texture = load("res://resources/sprites/black/knight1.png")

func can_move_to() -> Array[Vector2i]:
	var valid_moves: Array[Vector2i] = []
	var knight_moves = [
		Vector2i(2, 1), Vector2i(2, -1),
		Vector2i(-2, 1), Vector2i(-2, -1),
		Vector2i(1, 2), Vector2i(1, -2),
		Vector2i(-1, 2), Vector2i(-1, -2)
	]
	
	for move in knight_moves:
		var new_pos = Vector2i(position.x + move.x, position.y + move.y)
		if (new_pos.x >= 0 and new_pos.x < 8 and new_pos.y >= 0 and new_pos.y < 8
		 and BoardState.board[new_pos.x][new_pos.y] == null):
			valid_moves.append(new_pos)
			
	return valid_moves

func attack_targets() -> Array[Vector2i]:
	var valid_targets: Array[Vector2i] = []
	var moves = [
		Vector2i(2, 1), Vector2i(2, -1),
		Vector2i(-2, 1), Vector2i(-2, -1),
		Vector2i(1, 2), Vector2i(1, -2),
		Vector2i(-1, 2), Vector2i(-1, -2)
	]
	
	for move in moves:
		var new_pos = Vector2i(position.x + move.x, position.y + move.y)
		## Ignore out of bounds
		if new_pos.x < 0 or new_pos.x >= BoardState.COLS or new_pos.y < 0 or new_pos.y >= BoardState.COLS:
			break
			
		var other_piece: Piece = BoardState.board[new_pos.x][new_pos.y]
		if other_piece:
			if (new_pos.x >= 0 and new_pos.x < 8 and new_pos.y >= 0 and new_pos.y < 8
			 and other_piece.color != color):
				valid_targets.append(new_pos)

	return valid_targets
	
