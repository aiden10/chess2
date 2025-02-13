extends Node

signal piece_selected
signal ability_selected
signal game_won(winner_color)
signal tile_clicked(other_piece, row, col)
signal tile_entered(other_piece, row, col)
signal tile_exited()

## For any UI things that would happen on hit
signal piece_hit(piece, row, col)

signal overlay_drawn()
