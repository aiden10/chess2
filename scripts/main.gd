extends Node

@onready var boardNode = $Board

func _ready() -> void:
	BoardFunctions.populate_board()
	boardNode.initialize()
	EventBus.tile_clicked.connect(selection_handler)
	
func end_turn() -> void:
	## Alternate between 0 and 1
	GameState.turn = int(!bool(GameState.turn))
	print("Turn: " + Piece.PieceColor.keys()[GameState.turn])

func selection_handler(other_piece: Piece, row: int, col: int) -> void:
	
	## Basically just toggling the selection
	if other_piece == GameState.selected_piece:
		GameState.selected_piece = null

	## Move
	elif not other_piece and GameState.selected_piece and GameState.selected_piece.color == GameState.turn:
		
		## Deselect piece if they select an empty tile that cannot be moved to 
		if Vector2i(row, col) not in GameState.selected_piece.can_move_to():
			GameState.selected_piece = null
		## Otherwise, it's a valid move
		else:
			move(other_piece, row, col)

	elif other_piece and GameState.selected_piece and other_piece.color != GameState.turn:
		attack(other_piece, row, col)

	## Not moving and not toggling selection, so just update the selected piece
	else:
		GameState.selected_piece = other_piece

func move(other_piece: Piece, row: int, col: int) -> void:
	if Vector2i(row, col) in GameState.selected_piece.can_move_to():
		## Update board to the new piece's position
		BoardState.board[row][col] = GameState.selected_piece
		BoardState.board[GameState.selected_piece.position.x][GameState.selected_piece.position.y] = null
		GameState.selected_piece.position = Vector2i(row, col)
		GameState.selected_piece.has_moved = true
		GameState.selected_piece = null
		end_turn()

func attack(other_piece: Piece, row: int, col: int) -> void:
	print("attacking")
	GameState.selected_piece = null
	pass
