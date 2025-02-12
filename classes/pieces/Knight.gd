extends Piece

class_name Knight

func _init(piece_color: PieceColor) -> void:
	super._init(PieceType.KNIGHT, piece_color)
	self.strength = Constants.KNIGHT_STRENGTH
	self.health = Constants.KNIGHT_HP
	self.passive = passive_ability
	self.primary = primary_ability
	self.ultimate = ultimate_ability
	if piece_color == PieceColor.WHITE:
		self.texture = load("res://resources/sprites/white/knight.png")
	else:
		self.texture = load("res://resources/sprites/black/knight1.png")

func passive_ability() -> void:
	pass

func primary_ability() -> void:
	pass

func ultimate_ability() -> void:
	pass

func can_move_to(from_pos: Vector2i, to_pos: Vector2i, board: Array) -> bool:
	return true
