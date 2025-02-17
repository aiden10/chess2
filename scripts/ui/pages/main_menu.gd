extends CenterContainer

@onready var local_play_button: Button = $VBoxContainer/LocalPlayButton
@onready var create_room_button: Button = $VBoxContainer/CreateRoomButton
@onready var browser_button: Button = $VBoxContainer/BrowserButton
@export var local_play_scene: PackedScene
@export var create_room_scene: PackedScene
@export var browser_scene: PackedScene

func _ready() -> void:
	local_play_button.pressed.connect(initialize_local_play_scene)
	create_room_button.pressed.connect(initialize_create_room_scene)
	browser_button.pressed.connect(initialize_browser_scene)
	
func initialize_local_play_scene() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func initialize_create_room_scene() -> void:
	get_tree().change_scene_to_file("res://scenes/pages/create_room.tscn")
	
func initialize_browser_scene() -> void:
	get_tree().change_scene_to_file("res://scenes/pages/room_browser.tscn")
