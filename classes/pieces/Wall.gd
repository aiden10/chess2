extends Piece

class_name Wall

func _init(piece_color: PieceColor) -> void:
	super._init(PieceType.WALL, piece_color)
	self.strength = Constants.WALL_STRENGTH
	self.health = Constants.WALL_HP
	self.max_health = Constants.WALL_HP
	self.attack_range = Constants.WALL_RANGE
	self.texture = load("res://resources/sprites/wall.png")

## A Wall cannot move or attack 
func can_move_to() -> Array[Vector2i]:
	return []
	
func attack_targets() -> Array[Vector2i]:
	return []
	
