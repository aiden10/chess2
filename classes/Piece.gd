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
var strength: int
var has_moved: bool = false
var passive: Callable
var primary: Callable
var ultimate: Callable
var texture: Texture2D  

func _init(piece_type: PieceType, piece_color: PieceColor) -> void:
	type = piece_type
	color = piece_color

func take_damage(amount: int) -> bool:
	health -= amount
	return health <= 0  # Return true if piece is defeated

func can_move_to(from_pos: Vector2i, to_pos: Vector2i, board: Array) -> bool:
	# Base movement validation
	# Child classes will override this with specific movement patterns
	return true

func _to_string() -> String:
	return str(PieceColor.keys()[color]) + " " + str(PieceType.keys()[type])
