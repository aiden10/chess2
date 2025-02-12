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

func can_move_to(from_pos: Vector2i, to_pos: Vector2i, board: Array) -> bool:
	return true
