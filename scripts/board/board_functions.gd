extends Node

class_name BoardFunctions

## TODO 
## Check if any friendly pieces can block the check
## Check if any piece can be killed to stop the check 
static func is_checkmate() -> void:
	for color in Piece.PieceColor:
		var king: Piece = _find_king(Piece.PieceColor[color])
		
		## King was killed
		if not king:
			return 
		var enemy_valid_moves = _enemy_valid_moves(Piece.PieceColor[color])

		# Only check for checkmate if king is in check
		if king.position in enemy_valid_moves:
			# Check if king can escape
			var can_escape = false
			for king_move in king.can_move_to():
				if king_move not in enemy_valid_moves:
					can_escape = true
					break

			# If king can't escape, it's checkmate
			if not can_escape:
				var winner = Piece.PieceColor.WHITE if color == Piece.PieceColor.BLACK else Piece.PieceColor.BLACK
				EventBus.game_won.emit(winner)
				
static func _find_king(side: Piece.PieceColor) -> Piece:
	for row in BoardState.board.size():
		for col in BoardState.board[row].size():
			if BoardState.board[row][col] != null:
				var piece: Piece = BoardState.board[row][col]
				if piece.color == side and piece.type == Piece.PieceType.KING:
					return piece
	return
	
static func _enemy_valid_moves(side: Piece.PieceColor) -> Array[Vector2i]:
	var moves: Array[Vector2i] = []
	for row in BoardState.board.size():
		for col in BoardState.board[row].size():
			if BoardState.board[row][col] != null:
				var piece: Piece = BoardState.board[row][col]
				if piece.color != side:
					for move in piece.can_move_to():
						moves.append(move)		
	return moves

static func reset_board() -> void:
	for row in BoardState.board.size():
		for col in BoardState.board[row].size():
			BoardState.board[row][col] = null

static func populate_board() -> void:
	## White pieces back row (from left to right: 0,0 to 7,0)
	var white_rook1 = Rook.new(Piece.PieceColor.WHITE)
	white_rook1.position = Vector2i(0, 0)
	var white_knight1 = Knight.new(Piece.PieceColor.WHITE)
	white_knight1.position = Vector2i(0, 1)
	var white_bishop1 = Bishop.new(Piece.PieceColor.WHITE)
	white_bishop1.position = Vector2i(0, 2)
	var white_queen = Queen.new(Piece.PieceColor.WHITE)
	white_queen.position = Vector2i(0, 3)
	var white_king = King.new(Piece.PieceColor.WHITE)
	white_king.position = Vector2i(0, 4)
	var white_bishop2 = Bishop.new(Piece.PieceColor.WHITE)
	white_bishop2.position = Vector2i(0, 5)
	var white_knight2 = Knight.new(Piece.PieceColor.WHITE)
	white_knight2.position = Vector2i(0, 6)
	var white_rook2 = Rook.new(Piece.PieceColor.WHITE)
	white_rook2.position = Vector2i(0, 7)

	BoardState.board[0][0] = white_rook1
	BoardState.board[0][1] = white_knight1
	BoardState.board[0][2] = white_bishop1
	BoardState.board[0][3] = white_queen
	BoardState.board[0][4] = white_king
	BoardState.board[0][5] = white_bishop2
	BoardState.board[0][6] = white_knight2
	BoardState.board[0][7] = white_rook2

	## White pawns (row 1)
	for col in range(BoardState.COLS):
		var white_pawn = Pawn.new(Piece.PieceColor.WHITE)
		white_pawn.position = Vector2i(1, col)
		white_pawn.primary = Abilities.white_reverse_ability
		BoardState.board[1][col] = white_pawn

	## Black pieces back row (from left to right: 0,7 to 7,7)
	var black_rook1 = Rook.new(Piece.PieceColor.BLACK)
	black_rook1.position = Vector2i(7, 0)
	var black_knight1 = Knight.new(Piece.PieceColor.BLACK)
	black_knight1.position = Vector2i(7, 1)
	var black_bishop1 = Bishop.new(Piece.PieceColor.BLACK)
	black_bishop1.position = Vector2i(7, 2)
	var black_queen = Queen.new(Piece.PieceColor.BLACK)
	black_queen.position = Vector2i(7, 3)
	var black_king = King.new(Piece.PieceColor.BLACK)
	black_king.position = Vector2i(7, 4)
	var black_bishop2 = Bishop.new(Piece.PieceColor.BLACK)
	black_bishop2.position = Vector2i(7, 5)
	var black_knight2 = Knight.new(Piece.PieceColor.BLACK)
	black_knight2.position = Vector2i(7, 6)
	var black_rook2 = Rook.new(Piece.PieceColor.BLACK)
	black_rook2.position = Vector2i(7, 7)

	BoardState.board[7][0] = black_rook1
	BoardState.board[7][1] = black_knight1
	BoardState.board[7][2] = black_bishop1
	BoardState.board[7][3] = black_queen
	BoardState.board[7][4] = black_king
	BoardState.board[7][5] = black_bishop2
	BoardState.board[7][6] = black_knight2
	BoardState.board[7][7] = black_rook2

	## Black pawns (row 6)
	for col in range(BoardState.COLS):
		var black_pawn = Pawn.new(Piece.PieceColor.BLACK)
		black_pawn.position = Vector2i(6, col)
		black_pawn.primary = Abilities.black_reverse_ability
		BoardState.board[6][col] = black_pawn

	## Assign abilty objects
	white_bishop1.primary = Abilities.white_heal_ability
	white_bishop2.primary = Abilities.white_heal_ability
	black_bishop1.primary = Abilities.black_heal_ability
	black_bishop2.primary = Abilities.black_heal_ability

	white_rook1.primary = Abilities.white_barricade_ability
	white_rook2.primary = Abilities.white_barricade_ability
	black_rook1.primary = Abilities.black_barricade_ability
	black_rook2.primary = Abilities.black_barricade_ability
	
	white_knight1.primary = Abilities.white_heal_ability
	white_knight2.primary = Abilities.white_heal_ability
	black_knight1.primary = Abilities.black_heal_ability
	black_knight2.primary = Abilities.black_heal_ability
	
	white_queen.primary = Abilities.white_heal_ability
	black_queen.primary = Abilities.black_heal_ability
	
	white_king.primary = Abilities.white_inspire_ability
	black_king.primary = Abilities.black_inspire_ability
	
