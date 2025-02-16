extends CenterContainer

@onready var local_play_button: Button = $VBoxContainer/LocalPlayButton
@onready var create_room_button: Button = $VBoxContainer/CreateRoomButton
@onready var browser_button: Button = $VBoxContainer/BrowserButton

func _ready() -> void:
	local_play_button.pressed.connect(initialize_local_play_scene)
	create_room_button.pressed.connect(initialize_create_room_scene)
	browser_button.pressed.connect(initialize_browser_scene)

func initialize_local_play_scene() -> void:
	get_tree().paused = false
	
	# Load and instance the new game scene first
	var new_game = load("res://scenes/main.tscn").instantiate()
	
	# Get the root node
	var root = get_tree().root
	
	# Add the new game scene
	root.add_child(new_game)
	
	# Update current_scene reference
	get_tree().current_scene = new_game
	
	# Clean up the menu scene last
	queue_free()
	
func initialize_create_room_scene() -> void:
	pass
func initialize_browser_scene() -> void:
	pass
	
	
