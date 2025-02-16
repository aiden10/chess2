class_name InspireAbility
extends Ability

func _init() -> void:
	sprite = AbilityInfo.inspire_sprite
	name = AbilityInfo.inspire_name
	description = AbilityInfo.inspire_description
	cooldown = 0
	
## Basing the position off of the selected piece because in order to use an ability
## you need to have that piece selected
func valid_tiles() -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	for row in BoardState.board.size():
		for col in BoardState.board[row].size():
			var piece: Piece = BoardState.board[row][col]
			if piece:
				if piece.type != Piece.PieceType.WALL:
					## Friendly piece that is not the currently selected piece, has an ability on cooldown and is not a wall
					if (piece.color == GameState.selected_piece.color and piece.position != GameState.selected_piece.position
					and piece.primary.cooldown != 0):
						tiles.append(Vector2i(row, col))
	return tiles

func activate(row: int, col: int) -> void:
	var target: Piece = BoardState.board[row][col]
	if target:
		target.primary.cooldown = 0
		cooldown = AbilityInfo.inspire_cooldown
