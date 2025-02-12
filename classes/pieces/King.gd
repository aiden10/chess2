extends Piece

class_name King

func _init(piece_color: PieceColor) -> void:
	super._init(PieceType.KING, piece_color)
	self.strength = Constants.KING_STRENGTH
	self.health = Constants.KING_HP
	self.passive = passive_ability
	self.primary = primary_ability
	self.ultimate = ultimate_ability
	if piece_color == PieceColor.WHITE:
		self.texture = load("res://resources/sprites/white/king.png")
	else:
		self.texture = load("res://resources/sprites/black/king1.png")

func passive_ability() -> void:
	pass

func primary_ability() -> void:
	pass

func ultimate_ability() -> void:
	pass

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
		if new_pos.x >= 0 and new_pos.x < 8 and new_pos.y >= 0 and new_pos.y < 8:
			valid_moves.append(new_pos)
			
	return valid_moves
