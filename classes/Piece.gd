class_name Piece

enum PieceType {
	PAWN,
	ROOK,
	KNIGHT,
	BISHOP,
	QUEEN,
	KING
}

enum PieceColor {
	WHITE,
	BLACK
}

var type: PieceType
var color: PieceColor
var health: int
var max_hp: int
var strength: int
var attack_range: int
var has_moved: bool = false
var passive: Callable
var primary: Callable
var ultimate: Callable
var texture: Texture2D
var position: Vector2i

func _init(piece_type: PieceType, piece_color: PieceColor) -> void:
	type = piece_type
	color = piece_color

func take_damage(amount: int) -> bool:
	health -= amount
	return health <= 0  # Return true if piece is defeated

# Child classes will override this with specific movement patterns
func can_move_to() -> Array[Vector2i]:
	return []

func attack_targets() -> Array[Vector2i]:
	return []

func passive_ability() -> void:
	pass

func primary_ability() -> void:
	pass

func ultimate_ability() -> void:
	pass

func _to_string() -> String:
	return str(PieceColor.keys()[color]) + " " + str(PieceType.keys()[type])
