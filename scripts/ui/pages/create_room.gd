extends CenterContainer

@onready var create_room_button: Button = $VBoxContainer/CreateRoomButton
@onready var room_field: LineEdit = $VBoxContainer/HBoxContainer/RoomNameField
@onready var password_field: LineEdit = $VBoxContainer/HBoxContainer2/PasswordField
@export var multiplayer_scene: PackedScene

func _ready() -> void:
	create_room_button.pressed.connect(_create_room)
	NetworkManager.connection_established.connect(_on_connection_established)
	NetworkManager.connection_error.connect(_on_connection_error)
	
func _load_multiplayer() -> void:
	get_tree().paused = false
	
	# Load and instance the new game scene first
	var new_game = multiplayer_scene.instantiate()
	
	# Get the root node
	var root = get_tree().root
	
	# Add the new game scene
	root.add_child(new_game)
	
	# Update current_scene reference
	get_tree().current_scene = new_game
	
	# Clean up the menu scene last
	queue_free()

func _create_room() -> void:
	var room_name = room_field.text 
	var password = password_field.text
	NetworkManager.connect_to_room(room_name, password)

func _on_connection_established(player_color: String) -> void:
	print("Connected as ", player_color)
	_load_multiplayer()

func _on_connection_error(message: String) -> void:
	print("Connection error: ", message)
