extends CenterContainer

@onready var create_room_button: Button = $VBoxContainer/CreateRoomButton
@onready var back_button: Button = $VBoxContainer/BackButton
@onready var room_field: LineEdit = $VBoxContainer/HBoxContainer/RoomNameField
@onready var password_field: LineEdit = $VBoxContainer/HBoxContainer2/PasswordField
@export var multiplayer_scene: PackedScene

func _ready() -> void:
	create_room_button.pressed.connect(_create_room)
	back_button.pressed.connect(_back)
	NetworkManager.connection_established.connect(_on_connection_established)
	NetworkManager.connection_error.connect(_on_connection_error)

func _back() -> void:
	get_tree().change_scene_to_file("res://scenes/pages/main_menu.tscn")

func _create_room() -> void:
	var room_name = room_field.text 
	var password = password_field.text
	NetworkManager.connect_to_room(room_name, password)

func _on_connection_established(player_color: int) -> void:
	print("Connected as ", player_color)
	get_tree().change_scene_to_file("res://scenes/multiplayer.tscn")

func _on_connection_error(message: String) -> void:
	print("Connection error: ", message)
