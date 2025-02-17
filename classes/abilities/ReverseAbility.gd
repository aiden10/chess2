class_name ReverseAbility
extends Ability

func _init() -> void:
	sprite = AbilityInfo.reverse_sprite
	name = AbilityInfo.reverse_name
	description = AbilityInfo.reverse_description
	cooldown_duration = AbilityInfo.reverse_cooldown
	cooldown = 0

## Basing the position off of the selected piece because in order to use an ability
## you need to have that piece selected
func valid_tiles() -> Array[Vector2i]:
	var tiles: Array[Vector2i] = [GameState.selected_piece.position]
	return tiles

func activate(row: int, col: int) -> void:
	var target: Piece = BoardState.board[row][col]
	if target:
		if target.type == Piece.PieceType.PAWN:
			target.reversed = not target.reversed
			reset_cooldown()
