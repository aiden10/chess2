extends Node

@onready var boardNode = $Board

func _ready() -> void:
	BoardFunctions.populate_board()
	boardNode.initialize()
	GameState.turn = 0
	GameState.current_game_scene = self
	
