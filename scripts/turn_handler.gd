extends Node

@export var win_screen_scene: PackedScene

func _ready() -> void:
	EventBus.game_won.connect(game_won)
	EventBus.turn_ended.connect(end_turn)

func game_won(winner: Piece.PieceColor) -> void:
	if winner == Piece.PieceColor.WHITE:
		GameState.winner = "White"
	else:
		GameState.winner = "Black"
	var win_screen = win_screen_scene.instantiate()
	win_screen.winner = GameState.winner
	get_tree().root.add_child.call_deferred(win_screen)
	win_screen.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true

func start_turn() -> void:
	var abilities = Abilities.white_abilities + Abilities.black_abilities
	for ability in abilities:
		if ability.cooldown > 0:
			ability.cooldown -= 1

func end_turn() -> void:
	## Alternate between 0 and 1
	GameState.turn = int(!bool(GameState.turn))
	GameState.selected_piece = null
	GameState.selected_ability = null
	print("Turn: " + Piece.PieceColor.keys()[GameState.turn])
	start_turn()
	## Check for checkmate after each turn (i.e. after a piece has moved)
	# BoardFunctions.is_checkmate()
