class_name SwapAbility
extends Ability

func _init() -> void:
	sprite = AbilityInfo.swap_sprite
	name = AbilityInfo.swap_name
	description = AbilityInfo.swap_description
	cooldown = 0
	
## Basing the position off of the selected piece because in order to use an ability
## you need to have that piece selected
func valid_tiles() -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	# Get adjacent friendly pieces
	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			var pos = Vector2i(GameState.selected_piece.position.x + dx, GameState.selected_piece.position.y + dy)
			if is_in_bounds(pos):
				var piece = BoardState.board[pos.x][pos.y]
				if piece and piece.color == GameState.selected_piece.color and piece.position != GameState.selected_piece.position:
					tiles.append(pos)
	return tiles

func activate(row: int, col: int) -> void:
	var target = BoardState.board[row][col]
	if target:
		## Swap the piece's positions
		var temp = target.position
		BoardState.board[target.position.x][target.position.y] = GameState.selected_piece
		BoardState.board[GameState.selected_piece.position.x][GameState.selected_piece.position.y] = target
		target.position = GameState.selected_piece.position
		GameState.selected_piece.position = temp
		
		cooldown = AbilityInfo.swap_cooldown
