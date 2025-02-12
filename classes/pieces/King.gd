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

func can_move_to(from_pos: Vector2i, to_pos: Vector2i, board: Array) -> bool:
	return true
