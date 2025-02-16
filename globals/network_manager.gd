extends Node

signal connection_established(player_color: String)
signal game_started
signal state_updated(game_state: Dictionary, board_state: Dictionary)
signal player_disconnected(message: String)
signal connection_error(message: String)

var socket: WebSocketPeer
var is_connected := false
var room_info: Dictionary

## TODO
func serialize_game_state() -> Dictionary:
	return {}
	
func serialize_board_state() -> Dictionary:
	return {}

func connect_to_room(room_name: String, password: String) -> void:
	room_info = {
		"room_name": room_name,
		"password": password
	}
	
	socket = WebSocketPeer.new()
	var err = socket.connect_to_url(Constants.SOCKET_URL)
	
	if err != OK:
		connection_error.emit("Failed to connect to server")
		return
		
	# Start processing socket state
	set_process(true)

func send_game_state(game_state: Dictionary, board_state: Dictionary) -> void:
	if not is_connected:
		return
		
	var data = {
		"type": "move",
		"game_state": game_state,
		"board_state": board_state
	}
	socket.send_string(JSON.stringify(data))

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
				socket.send_string(JSON.stringify(room_info))
			
			while socket.get_available_packet_count():
				var packet = socket.get_packet()
				var data = JSON.parse_string(packet.get_string_from_utf8())
				
				match data["type"]:
					"connected":
						connection_established.emit(data["color"])
						if data.has("game_state"):
							state_updated.emit(data["game_state"], data["board_state"])
					
					"game_start":
						game_started.emit()
						state_updated.emit(data["game_state"], {})
					
					"state_update":
						state_updated.emit(data["game_state"], data["board_state"])
					
					"player_disconnected":
						player_disconnected.emit(data["message"])
					
					"error":
						connection_error.emit(data["message"])
		
		WebSocketPeer.STATE_CLOSED:
			set_process(false)
			connection_error.emit("Connection closed")
