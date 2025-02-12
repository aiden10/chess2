extends Node

var board: Array
const ROWS = 8
const COLS = 8

func _ready() -> void:
	board = []
	for row in ROWS:
		var new_row = []
		new_row.resize(COLS)
		board.append(new_row)
