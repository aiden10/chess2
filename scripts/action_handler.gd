extends Node

func _ready() -> void:
	EventBus.tile_clicked.connect(selection_handler)

## [other_piece]: the board value at the position that was clicked
## [row], [col]: the x and y position of the clicked tile
func selection_handler(other_piece: Piece, row: int, col: int) -> void:
	## Check if ability used
	if GameState.selected_ability and GameState.selected_piece and GameState.selected_piece.color == GameState.turn:
		if Vector2i(row, col) in GameState.selected_ability.valid_tiles():
			GameState.selected_ability.activate(row, col)
			EventBus.turn_ended.emit()
			return
	GameState.selected_ability = null
	
	## Basically just toggling the selection
	if other_piece == GameState.selected_piece:
		GameState.selected_piece = null

	## Move conditions
	elif not other_piece and GameState.selected_piece and GameState.selected_piece.color == GameState.turn and not GameState.selected_ability:
		## Deselect piece if they select an empty tile that cannot be moved to 
		if Vector2i(row, col) not in GameState.selected_piece.can_move_to():
			GameState.selected_piece = null
		## Otherwise, it's a valid move
		else:
			move(other_piece, row, col)
	
	## Attack conditions
	elif other_piece and GameState.selected_piece and other_piece.color != GameState.turn and not GameState.selected_ability:
		if Vector2i(row, col) not in GameState.selected_piece.attack_targets():
			GameState.selected_piece = other_piece
		else:
			attack(other_piece, row, col)
		
	## Not moving and not toggling selection, so just update the selected piece
	else:
		GameState.selected_piece = other_piece

## Handle onkill events, mainly those from passive abilities
func kill_events(attacker: Piece, victim: Piece) -> void:
	pass

## [other_piece]: the board value at the position that was clicked
## [row], [col]: the x and y position of the clicked tile
func move(other_piece: Piece, row: int, col: int) -> void:
	if Vector2i(row, col) in GameState.selected_piece.can_move_to():
		## Update board to the new piece's position
		BoardState.board[row][col] = GameState.selected_piece
		BoardState.board[GameState.selected_piece.position.x][GameState.selected_piece.position.y] = null
		GameState.selected_piece.position = Vector2i(row, col)
		GameState.selected_piece.has_moved = true
		EventBus.turn_ended.emit()

## [other_piece]: the board value at the position that was clicked
## [row], [col]: the x and y position of the clicked tile
func attack(other_piece: Piece, row: int, col: int) -> void:
	var selected_piece: Piece = GameState.selected_piece
	if selected_piece and other_piece:
		if Vector2i(row, col) in selected_piece.attack_targets():
			var prev_position = selected_piece.position
			
			## Calculate if this is a mutual attack
			var counter_attack = prev_position in other_piece.attack_targets()
			
			## Apply damage both ways if it's a mutual attack
			var defender_dead = other_piece.take_damage(selected_piece.strength)
			var attacker_dead = false
			if counter_attack:
				attacker_dead = selected_piece.take_damage(other_piece.strength)
			
			## Handle piece removal and movement based on what died
			## Both pieces died - clear both positions
			if defender_dead and attacker_dead:
				BoardState.board[selected_piece.position.x][selected_piece.position.y] = null
				BoardState.board[row][col] = null
				kill_events(selected_piece, other_piece)
				kill_events(other_piece, selected_piece)

			## Only defender died - move attacker to new position
			elif defender_dead and not attacker_dead:
				BoardState.board[selected_piece.position.x][selected_piece.position.y] = null
				BoardState.board[row][col] = selected_piece
				selected_piece.position = Vector2i(row, col)
				kill_events(selected_piece, other_piece)

			## Only attacker died - just remove it from its position
			elif attacker_dead and not defender_dead:
				BoardState.board[selected_piece.position.x][selected_piece.position.y] = null
				kill_events(other_piece, selected_piece)
			
			EventBus.turn_ended.emit()
