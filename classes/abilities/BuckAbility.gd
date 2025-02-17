class_name BuckAbility
extends Ability

func _init() -> void:
	sprite = AbilityInfo.buck_sprite
	name = AbilityInfo.buck_name
	description = AbilityInfo.buck_description
	cooldown = 0
	cooldown_duration = AbilityInfo.buck_cooldown

## Basing the position off of the selected piece because in order to use an ability
## you need to have that piece selected
func valid_tiles() -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			var pos = Vector2i(GameState.selected_piece.position.x + dx, GameState.selected_piece.position.y + dy)
			if is_in_bounds(pos):
				var piece = BoardState.board[pos.x][pos.y]
				## Adjacent enemy piece
				if piece and piece.color != GameState.selected_piece.color:
					tiles.append(pos)
	return tiles

func activate(row: int, col: int) -> void:
	var target: Piece = BoardState.board[row][col]
	if target:
		var dead = target.take_damage(AbilityInfo.buck_damage)
		if dead:
			BoardState.board[row][col] = null
		reset_cooldown()
