extends Piece

class_name Rook

func _init(piece_color: PieceColor) -> void:
	super._init(PieceType.ROOK, piece_color)
	self.strength = Constants.ROOK_STRENGTH
	self.health = Constants.ROOK_HP
	self.passive = passive_ability
	self.primary = primary_ability
	self.ultimate = ultimate_ability
	if piece_color == PieceColor.WHITE:
		self.texture = load("res://resources/sprites/white/rook.png")
	else:
		self.texture = load("res://resources/sprites/black/rook1.png")

func passive_ability() -> void:
	pass

func primary_ability() -> void:
	pass

func ultimate_ability() -> void:
	pass

## Returns a list of positions that this piece can move to
func can_move_to() -> Array[Vector2i]:
	var valid_moves: Array[Vector2i] = []

	# Horizontal and vertical moves
	for i in range(8):
		if i != position.x:
			valid_moves.append(Vector2i(i, position.y))  # Horizontal
		if i != position.y:
			valid_moves.append(Vector2i(position.x, i))  # Vertical
			
	return valid_moves
