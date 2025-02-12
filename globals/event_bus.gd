extends Node

signal piece_selected
signal tile_clicked(other_piece, row, col)
signal tile_entered(other_piece, row, col)
signal tile_exited()
## For any UI things that would happen on hit
signal piece_hit(piece, row, col)
