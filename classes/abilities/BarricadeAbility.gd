class_name BarricadeAbility
extends Ability

func _init() -> void:
	sprite = AbilityInfo.barricade_sprite
	name = AbilityInfo.barricade_name
	description = AbilityInfo.barricade_description

## Basing the position off of the selected piece because in order to use an ability
## you need to have that piece selected
func valid_tiles() -> Array[Vector2i]:
	var directions = [
		Vector2i(0, 1),   # Up
		Vector2i(0, -1),  # Down 
		Vector2i(-1, 0),  # Left
		Vector2i(1, 0)  # Right
	]
	var tiles: Array[Vector2i] = []
	for direction in directions:
		for i in range(1, GameState.selected_piece.attack_range):
			var pos = Vector2i(
				GameState.selected_piece.position.x + (direction.x * i),
				GameState.selected_piece.position.y + (direction.y * i)
			)
			
			# Check if position is out of bounds
			if pos.x < 0 or pos.x >= BoardState.COLS or pos.y < 0 or pos.y >= BoardState.COLS:
				continue  # Stop checking this direction if we're out of bounds
				
			# Can't place a wall where a piece already is
			if BoardState.board[pos.x][pos.y] != null:
				break # Stop checking this direction if a piece is in the way
				
			tiles.append(pos)
	
	return tiles

func activate(row: int, col: int) -> void:
	var wall = Wall.new(GameState.selected_piece.color) ## Make the wall the same color as its creator
	wall.position = Vector2i(row, col)
	BoardState.board[row][col] = wall
	
