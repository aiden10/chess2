extends CenterContainer

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var room_container: VBoxContainer = $VBoxContainer/ScrollContainer/RoomContainer
@onready var join_button: Button = $VBoxContainer/JoinButton
@onready var back_button: Button = $VBoxContainer/BackButton
@onready var password_field: LineEdit = $VBoxContainer/HBoxContainer/PasswordField
var selected_room: String
var rooms: Array = []

func _ready() -> void:
	back_button.pressed.connect(_back)
	join_button.pressed.connect(_join_button_pressed)
	NetworkManager.connection_established.connect(_on_connection_established)
	NetworkManager.connection_error.connect(_on_connection_error)
	http_request.request_completed.connect(_on_request_completed)
	http_request.request(Constants.SERVER_URL + "rooms")
	
func _on_request_completed(result, _response_code, _headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		var json = JSON.parse_string(body.get_string_from_utf8())
		rooms = json["rooms"]
		for room in rooms:
			add_room(room["name"])

func add_room(room_name: String) -> void:
	var room_button: Button = Button.new()
	room_button.text = room_name
	room_container.add_child(room_button)
	room_button.pressed.connect(Callable(select_room).bind(room_button.text))

func select_room(room_name: String) -> void:
	selected_room = room_name

func _join_button_pressed() -> void:
	join(selected_room, password_field.text)

func join(room_name: String, password: String) -> void:
	var result: bool = NetworkManager.connect_to_room(room_name, password)
	if not result:
		print("Invalid password")
		
func _on_connection_established(player_color: int) -> void:
	print("Connected as ", player_color)
	get_tree().change_scene_to_file("res://scenes/multiplayer.tscn")

func _on_connection_error(message: String) -> void:
	print("Connection error: ", message)

func _back() -> void:
	get_tree().change_scene_to_file("res://scenes/pages/main_menu.tscn")
