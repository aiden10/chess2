extends Node

@onready var boardNode = $Board

func _ready() -> void:
	BoardFunctions.populate_board()
	boardNode.initialize()
	NetworkManager.state_updated.connect(_on_state_updated)
	NetworkManager.game_started.connect(_on_game_started)
	NetworkManager.player_disconnected.connect(_on_player_disconnected)
	EventBus.piece_selected.connect(_selection_made)
	GameState.is_multiplayer = true

## When the other player does something
func _on_state_updated(game_state: Dictionary, board_state: Dictionary) -> void:
	GameState.current_turn = game_state["current_turn"]
	EventBus.piece_selected.emit()
	
func _on_game_started() -> void:
	pass

func _on_player_disconnected(message: String) -> void:
	pass

## When you do something
func _selection_made() -> void:
	var game_state = NetworkManager.serialize_game_state()
	var board_state = NetworkManager.serialize_board_state()
	NetworkManager.send_game_state(game_state, board_state)
	
