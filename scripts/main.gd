extends Node

@onready var boardNode = $Board

func _ready() -> void:
	BoardFunctions.populate_board()
	boardNode.initialize()
	EventBus.turn_ended.connect(end_turn)
	
func end_turn() -> void:
	## Alternate between 0 and 1
	GameState.turn = int(!bool(GameState.turn))
	print("Turn: " + Piece.PieceColor.keys()[GameState.turn])
