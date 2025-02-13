class_name HealAbility
extends Ability

func _init() -> void:
	sprite = AbilityInfo.heal_sprite
	name = AbilityInfo.heal_name
	description = AbilityInfo.heal_description

## Basing the position off of the selected piece because in order to use an ability
## you need to have that piece selected
func valid_tiles() -> Array[Vector2i]:
	var tiles: Array[Vector2i] = [] ## Can self-heal
	if GameState.selected_piece.health < GameState.selected_piece.max_health:
		tiles.append(GameState.selected_piece.position)
	# Get adjacent friendly pieces
	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			var pos = Vector2i(GameState.selected_piece.position.x + dx, GameState.selected_piece.position.y + dy)
			if is_in_bounds(pos):
				var piece = BoardState.board[pos.x][pos.y]
				if piece and piece.color == GameState.selected_piece.color and piece.health < piece.max_health:
					tiles.append(pos)
	return tiles

func activate(row: int, col: int) -> void:
	var target = BoardState.board[row][col]
	if target:
		target.health = min(target.health + 2, target.max_health)
