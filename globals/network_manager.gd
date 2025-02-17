extends Node

signal connection_established(player_color: int)
signal game_started
signal state_updated(game_state: Dictionary, board_state: Dictionary)
signal player_disconnected(message: String)
signal connection_error(message: String)

var socket: WebSocketPeer
var is_connected := false
var room_info: Dictionary

func serialize_game_state() -> Dictionary:
	var ability_type = ""
	var used_ability_name = GameState.used_ability_name
	
	## Ability used
	if used_ability_name != null:
		
		## Reset after an ability was used
		GameState.used_ability_name = null
		
		if used_ability_name in Abilities.black_ultimate_abilities.keys() + Abilities.white_ultimate_abilities.keys():
			ability_type = "ultimate"
		else:
			ability_type = "primary"
		
	return {
		"ability_type": ability_type,
		"used_ability_name": used_ability_name,
		"turn": GameState.turn
	}
	
func serialize_board_state() -> Dictionary:
	var serialized_board = []
	for row in BoardState.ROWS:
		var new_row = []
		new_row.resize(BoardState.COLS)
		serialized_board.append(new_row)

	for row in BoardState.ROWS:
		for col in BoardState.COLS:
			var piece: Piece = BoardState.board[row][col]
			if piece == null:
				serialized_board[row][col] = null
			else:
				serialized_board[row][col] = piece.serialize()
	return {
		"board_state": serialized_board
	}

func deserialize_game_state(game_state: Dictionary):
	GameState.turn = game_state["turn"]
	var ability_type = game_state["ability_type"]
	var used_ability_name = game_state["used_ability_name"]
	print(game_state)
	if used_ability_name != null and ability_type != "":
		var ability_dict
		if ability_type == "primary":
			ability_dict = Abilities.black_abilities if GameState.player_color == 0 else Abilities.white_abilities	
		else:
			ability_dict = Abilities.black_ultimate_abilities if GameState.player_color == 0 else Abilities.white_ultimate_abilities
		
		ability_dict[used_ability_name].reset_cooldown()
		
func deserialize_board_state(board_state: Dictionary):
	GameState.selected_piece = null
	var board = board_state["board_state"]
	BoardFunctions.reset_board()
	for row in board.size():
		for col in board[row].size():
			var piece_data = board[row][col]
			if piece_data == null:
				BoardState.board[row][col] = null
			else:
				var new_piece: Piece
				var piece_type = piece_data["type"]
				var piece_color = piece_data["color"]
				var piece_position = Vector2i(piece_data["position_x"], piece_data["position_y"])
				var piece_has_moved = piece_data["has_moved"]
				var piece_primary_name = piece_data["primary_name"]
				var piece_passive_name = piece_data["passive_name"]
				var piece_ultimate_name = piece_data["ultimate_name"]
				var piece_health = piece_data["health"]
				var piece_reversed = piece_data["reversed"]
				new_piece = Constants.pieces_dict[int(piece_type)].new(piece_color)
				new_piece.position = piece_position
				new_piece.has_moved = piece_has_moved
				new_piece.health = piece_health
				if piece_type == Piece.PieceType.PAWN:
					new_piece.reversed = piece_reversed
				if piece_primary_name:
					new_piece.primary = Abilities.black_abilities[piece_primary_name] if piece_color == 1 else Abilities.white_abilities[piece_primary_name]
				if piece_passive_name:
					new_piece.passive = Abilities.passive_abilities[piece_passive_name]
				if piece_ultimate_name:
					new_piece.ultimate = Abilities.black_ultimate_abilities[piece_ultimate_name] if piece_color == 1 else Abilities.white_ultimate_abilities[piece_ultimate_name]
				BoardState.board[row][col] = new_piece

	## Redraw board
	EventBus.piece_selected.emit()
	
func connect_to_room(room_name: String, password: String) -> bool:
	room_info = {
		"room_name": room_name,
		"password": password
	}
	
	socket = WebSocketPeer.new()
	var err = socket.connect_to_url(Constants.SOCKET_URL)
	
	if err != OK:
		connection_error.emit("Failed to connect to server")
		return false
			
	# Start processing socket state
	set_process(true)
	return true
	
func send_game_state(game_state: Dictionary, board_state: Dictionary) -> void:
	if not is_connected:
		return
		
	var data = {
		"game_state": game_state,
		"board_state": board_state
	}
	socket.send_text(JSON.stringify(data))

func close_connection() -> void:
	if socket:
		socket.close()  # This sends a close frame to the server
		set_process(false)
		GameState.players_ready = false
		GameState.player_color = 0
		socket = null  # Clear the socket reference
		
func _process(_delta: float) -> void:
	if not socket:
		return
		
	socket.poll()
	
	var state = socket.get_ready_state()
	
	match state:
		WebSocketPeer.STATE_OPEN:
			if not is_connected:
				is_connected = true
				# Send room info once connected
				socket.send_text(JSON.stringify(room_info))
			
			while socket.get_available_packet_count():
				var packet = socket.get_packet()
				var data = JSON.parse_string(packet.get_string_from_utf8())
				
				match data["type"]:
					"connected":
						connection_established.emit(data["color"])
						GameState.player_color = data["color"]
						if data.has("game_state"):
							state_updated.emit(data["game_state"], data["board_state"])
					
					"game_start":
						GameState.players_ready = true
						game_started.emit()
					
					"state_update":
						state_updated.emit(data["game_state"], data["board_state"])
					
					"player_disconnected":
						GameState.players_ready = false
						player_disconnected.emit(data["message"])
					
					"error":
						connection_error.emit(data["message"])
						close_connection()
						return
						
		WebSocketPeer.STATE_CLOSED:
			set_process(false)
			connection_error.emit("Connection closed")
