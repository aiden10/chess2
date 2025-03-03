class_name Piece

enum PieceType {
	PAWN,
	ROOK,
	KNIGHT,
	BISHOP,
	QUEEN,
	KING,
	WALL
}

enum PieceColor {
	WHITE,
	BLACK
}

var type: PieceType
var color: PieceColor
var health: int
var max_health: int
var strength: int
var attack_range: int
var has_moved: bool = false
var passive: Ability
var primary: Ability
var ultimate: Ability
var texture: Texture2D
var position: Vector2i

func _init(piece_type: PieceType, piece_color: PieceColor) -> void:
	type = piece_type
	color = piece_color

func take_damage(amount: int) -> bool:
	health -= amount
	if type == PieceType.KING and health <= 0:
		var winner = PieceColor.WHITE if color == PieceColor.BLACK else PieceColor.BLACK
		EventBus.game_won.emit(winner)
	return health <= 0  # Return true if piece is defeated

# Child classes will override this with specific movement patterns
func can_move_to() -> Array[Vector2i]:
	return []

func attack_targets() -> Array[Vector2i]:
	return []

func _to_string() -> String:
	return str(PieceColor.keys()[color]) + " " + str(PieceType.keys()[type])

func serialize() -> Dictionary:
	var passive_name = passive.name if passive != null else null
	var primary_name = primary.name if primary != null else null
	var ultimate_name = ultimate.name if ultimate != null else null
	var reverse = self.reversed if type == PieceType.PAWN else false
	return {
		"position_x": position.x,
		"position_y": position.y,
		"color": color,
		"type": type,
		"passive_name": passive_name,
		"primary_name": primary_name,
		"ultimate_name": ultimate_name,
		"has_moved": has_moved,
		"health": health,
		"reversed": reverse
 	}
