extends CenterContainer

@onready var create_room_button: Button = $VBoxContainer/CreateRoomButton
@onready var back_button: Button = $VBoxContainer/BackButton
@onready var room_field: LineEdit = $VBoxContainer/HBoxContainer/RoomNameField
@onready var password_field: LineEdit = $VBoxContainer/HBoxContainer2/PasswordField
@onready var http_request: HTTPRequest = $HTTPRequest

@export var multiplayer_scene: PackedScene

func _ready() -> void:
	create_room_button.pressed.connect(_create_room)
	back_button.pressed.connect(_back)
	http_request.request_completed.connect(_on_request_completed)
	NetworkManager.connection_established.connect(_on_connection_established)
	NetworkManager.connection_error.connect(_on_connection_error)

func _back() -> void:
	get_tree().change_scene_to_file("res://scenes/pages/main_menu.tscn")

func _create_room() -> void:
	var headers = ["Content-Type: application/json"]
	var room_name = room_field.text 
	var password = password_field.text
	var json = JSON.stringify({"name": room_name, "password": password})
	var err = http_request.request(Constants.SERVER_URL + "create_room", headers, HTTPClient.METHOD_POST, json)
	if err != OK:
		print("Failed to send request")
		return
		
func _on_request_completed(result, _response_code, _headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.parse_string(body.get_string_from_utf8())
		print(json["type"])
		if json["type"] == "success":
			NetworkManager.connect_to_room(room_field.text, password_field.text)
		else:
			print("Room creation failed:", json)
	else:
		print("Request failed with result:", result)	

func _on_connection_established(player_color: int) -> void:
	print("Connected as ", player_color)
	get_tree().change_scene_to_file("res://scenes/multiplayer.tscn")

func _on_connection_error(message: String) -> void:
	print("Connection error: ", message)
