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
	if GameState.selected_ability in Abilities.white_ultimate_abilities.values() + Abilities.black_ultimate_abilities.values():
		ability_type = "ultimate"
	else:
		ability_type = "primary"
	return {
		"selected_x": GameState.selected_piece.position.x,
		"selected_y": GameState.selected_piece.position.y,
		"ability_type": ability_type,
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
	var x = game_state["selected_x"]
	var y = game_state["selected_y"]
	var ability_type = game_state["ability_type"]
	var piece: Piece = BoardState.board[x][y]
	GameState.selected_piece = piece
	if piece:
		if ability_type == "primary":
			GameState.selected_ability = piece.primary
		else:
			GameState.selected_ability = piece.ultimate
	else:
		GameState.selected_ability = null
	
	## Redraw board
	EventBus.piece_selected.emit()
	EventBus.ability_selected.emit()
	
func deserialize_board_state(board_state: Dictionary):
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
				var piece_primary_name = piece_data["primary_name"]
				var piece_passive_name = piece_data["passive_name"]
				var piece_ultimate_name = piece_data["ultimate_name"]
				var piece_primary = Abilities.black_abilities[piece_primary_name] if piece_color == 1 else Abilities.white_abilities[piece_primary_name]
				if piece_passive_name:
					var piece_passive = Abilities.passive_abilities[piece_ultimate_name]
				if piece_ultimate_name:
					var piece_ultimate = Abilities.black_ultimate_abilities[piece_ultimate_name] if piece_color == 1 else Abilities.white_ultimate_abilities[piece_ultimate_name]
				new_piece = Constants.pieces_dict[piece_type].new(piece_color)
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
		"type": "move",
		"game_state": game_state,
		"board_state": board_state
	}
	socket.send_text(JSON.stringify(data))

func close_connection() -> void:
	if socket:
		socket.close()  # This sends a close frame to the server
		set_process(false)
		GameState.player_count = 0
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
				print(data)
				
				match data["type"]:
					"connected":
						connection_established.emit(data["color"])
						GameState.player_count += 1
						GameState.player_color = data["color"]
						if data.has("game_state"):
							state_updated.emit(data["game_state"], data["board_state"])
					
					"game_start":
						game_started.emit()
						state_updated.emit(data["game_state"], {})
					
					"state_update":
						state_updated.emit(data["game_state"], data["board_state"])
					
					"player_disconnected":
						GameState.player_count -= 1
						player_disconnected.emit(data["message"])
					
					"error":
						connection_error.emit(data["message"])
		
		WebSocketPeer.STATE_CLOSED:
			set_process(false)
			connection_error.emit("Connection closed")
