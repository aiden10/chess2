extends Node

signal piece_selected
signal tile_clicked(other_piece, row, col)

## For any UI things that would happen on hit
signal piece_hit(piece, row, col)
