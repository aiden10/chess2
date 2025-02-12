extends Piece

class_name Bishop

func _init(piece_color: PieceColor) -> void:
	super._init(PieceType.BISHOP, piece_color)
	self.strength = Constants.BISHOP_STRENGTH
	self.health = Constants.BISHOP_HP
	self.passive = passive_ability
	self.primary = primary_ability
	self.ultimate = ultimate_ability
	if piece_color == PieceColor.WHITE:
		self.texture = load("res://resources/sprites/white/bishop.png")
	else:
		self.texture = load("res://resources/sprites/black/bishop1.png")
		
func passive_ability() -> void:
	pass

func primary_ability() -> void:
	pass

func ultimate_ability() -> void:
	pass

func can_move_to() -> Array[Vector2i]:
	var valid_moves: Array[Vector2i] = []
	
	# Diagonal moves in all directions
	for i in range(1, 8):
		var positions = [
			Vector2i(position.x + i, position.y + i),  # Up-right
			Vector2i(position.x + i, position.y - i),  # Down-right
			Vector2i(position.x - i, position.y + i),  # Up-left
			Vector2i(position.x - i, position.y - i)   # Down-left
		]
		
		for pos in positions:
			if pos.x >= 0 and pos.x < 8 and pos.y >= 0 and pos.y < 8:
				valid_moves.append(pos)
				
	return valid_moves
