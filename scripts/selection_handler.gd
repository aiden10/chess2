extends Node

func _ready() -> void:
	EventBus.tile_entered.connect(tile_entered)
	EventBus.tile_exited.connect(tile_exited)
	
func tile_entered(other_piece: Piece, row: int, col: int) -> void:
	pass

func tile_exited() -> void:
	pass
