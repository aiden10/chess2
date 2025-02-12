extends Piece

class_name Pawn

func _init(piece_color: PieceColor) -> void:
	super._init(PieceType.PAWN, piece_color)
	self.strength = Constants.PAWN_STRENGTH
	self.health = Constants.PAWN_HP
	self.passive = passive_ability
	self.primary = primary_ability
	self.ultimate = ultimate_ability
	if piece_color == PieceColor.WHITE:
		self.texture = load("res://resources/sprites/white/pawn.png")
	else:
		self.texture = load("res://resources/sprites/black/pawn1.png")

func passive_ability() -> void:
	pass

func primary_ability() -> void:
	pass

func ultimate_ability() -> void:
	pass

func can_move_to() -> Array[Vector2i]:
	var valid_moves: Array[Vector2i] = []
	var direction = 1 if color == PieceColor.WHITE else -1

	# Forward one space
	var forward = Vector2i(position.x + direction, position.y)
	if forward.x >= 0 and forward.x < 8:
		valid_moves.append(forward)

	# Initial two space move
	if not has_moved:
		var double_forward = Vector2i(position.x + (2 * direction), position.y)
		if double_forward.x >= 0 and double_forward.x < 8:
			valid_moves.append(double_forward)
			
	return valid_moves
