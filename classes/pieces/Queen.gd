extends Piece

class_name Queen

func _init(piece_color: PieceColor) -> void:
	super._init(PieceType.QUEEN, piece_color)
	self.strength = Constants.QUEEN_STRENGTH
	self.health = Constants.QUEEN_HP
	self.passive = passive_ability
	self.primary = primary_ability
	self.ultimate = ultimate_ability
	if piece_color == PieceColor.WHITE:
		self.texture = load("res://resources/sprites/white/queen.png")
	else:
		self.texture = load("res://resources/sprites/black/queen1.png")

func passive_ability() -> void:
	pass

func primary_ability() -> void:
	pass

func ultimate_ability() -> void:
	pass

func can_move_to() -> Array[Vector2i]:
	var valid_moves: Array[Vector2i] = []
	
	# Combine rook and bishop moves
	# Horizontal and vertical (rook moves)
	for i in range(8):
		if i != position.x:
			valid_moves.append(Vector2i(i, position.y))
		if i != position.y:
			valid_moves.append(Vector2i(position.x, i))
	
	# Diagonal moves (bishop moves)
	for i in range(1, 8):
		var positions = [
			Vector2i(position.x + i, position.y + i),
			Vector2i(position.x + i, position.y - i),
			Vector2i(position.x - i, position.y + i),
			Vector2i(position.x - i, position.y - i)
		]
		
		for pos in positions:
			if pos.x >= 0 and pos.x < 8 and pos.y >= 0 and pos.y < 8:
				valid_moves.append(pos)
				
	return valid_moves
