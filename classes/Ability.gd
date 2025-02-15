class_name Ability
extends Resource

var sprite: Texture2D
var name: String
var description: String
var cooldown: int
var used: bool

# Abstract methods that child classes must implement
func valid_tiles() -> Array[Vector2i]:
	push_error("Valid tiles not implemented for base Ability")
	return []

func activate(row: int, col: int) -> void:
	push_error("Activate not implemented for base Ability")

func is_in_bounds(pos: Vector2i) -> bool:
	return (pos.x >= 0 and pos.x < BoardState.COLS and 
			pos.y >= 0 and pos.y < BoardState.ROWS)
			
func _to_string() -> String:
	return name
