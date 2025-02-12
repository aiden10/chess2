extends Piece

class_name King

func _init(piece_color: PieceColor) -> void:
	super._init(PieceType.KING, piece_color)
	self.strength = Constants.KING_STRENGTH
	self.health = Constants.KING_HP
	self.max_hp = Constants.KING_HP
	self.attack_range = Constants.KING_RANGE
	self.passive = passive_ability
	self.primary = primary_ability
	self.ultimate = ultimate_ability
	if piece_color == PieceColor.WHITE:
		self.texture = load("res://resources/sprites/white/king.png")
	else:
		self.texture = load("res://resources/sprites/black/king1.png")

func can_move_to() -> Array[Vector2i]:
	var valid_moves: Array[Vector2i] = []
	
	# All adjacent squares (including diagonals)
	var king_moves = [
		Vector2i(1, 0), Vector2i(-1, 0),    # Horizontal
		Vector2i(0, 1), Vector2i(0, -1),    # Vertical
		Vector2i(1, 1), Vector2i(1, -1),    # Diagonal right
		Vector2i(-1, 1), Vector2i(-1, -1)   # Diagonal left
	]
	
	for move in king_moves:
		var new_pos = Vector2i(position.x + move.x, position.y + move.y)
		if (new_pos.x >= 0 and new_pos.x < 8 and new_pos.y >= 0 and new_pos.y < 8
		 and BoardState.board[new_pos.x][new_pos.y] == null):
			valid_moves.append(new_pos)

	return valid_moves

func attack_targets() -> Array[Vector2i]:
	var valid_targets: Array[Vector2i] = []
	var king_moves = [
		Vector2i(1, 0), Vector2i(-1, 0),    # Horizontal
		Vector2i(0, 1), Vector2i(0, -1),    # Vertical
		Vector2i(1, 1), Vector2i(1, -1),    # Diagonal right
		Vector2i(-1, 1), Vector2i(-1, -1)   # Diagonal left
	]
	
	for move in king_moves:
		var new_pos = Vector2i(position.x + move.x, position.y + move.y)
		
		## Ignore out of bounds
		if new_pos.x < 0 or new_pos.x >= BoardState.COLS or new_pos.y < 0 or new_pos.y >= BoardState.COLS:
			break
			
		var other_piece: Piece = BoardState.board[new_pos.x][new_pos.y]
		if other_piece:
			var x_diff: int = abs(position.x - new_pos.x) 
			var y_diff: int = abs(position.y - new_pos.y) 
			if (other_piece.color != color and x_diff <= attack_range and y_diff <= attack_range):
				valid_targets.append(new_pos)

	return valid_targets
	
