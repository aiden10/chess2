extends Node

@onready var boardNode = $Board

func _ready() -> void:
	BoardFunctions.populate_board()
	boardNode.initialize()
	EventBus.move.connect(move)
	
func end_turn() -> void:
	## Alternate between 0 and 1
	GameState.turn = int(!bool(GameState.turn))
	print("Turn: " + Piece.PieceColor.keys()[GameState.turn])

func move(position: Piece, row: int , col: int) -> void:
	if Vector2i(row, col) in GameState.selected_piece.can_move_to():
		## Update board to the new piece's position
		BoardState.board[row][col] = GameState.selected_piece
		BoardState.board[GameState.selected_piece.position.x][GameState.selected_piece.position.y] = null
		GameState.selected_piece = null
		end_turn()
