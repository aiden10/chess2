extends CenterContainer

@onready var local_play_button: Button = $VBoxContainer/LocalPlayButton
@onready var create_room_button: Button = $VBoxContainer/CreateRoomButton
@onready var browser_button: Button = $VBoxContainer/BrowserButton
@export var local_play_scene: PackedScene
@export var create_room_scene: PackedScene
@export var browser_scene: PackedScene

func _ready() -> void:
	local_play_button.pressed.connect(func(): switch_scene(local_play_scene))
	create_room_button.pressed.connect(func(): switch_scene(create_room_scene))
	browser_button.pressed.connect(func(): switch_scene(browser_scene))
	
func switch_scene(scene: PackedScene) -> void:
	get_tree().paused = false	
	var new_scene = scene.instantiate()	
	var root = get_tree().root	
	root.add_child(new_scene)
	get_tree().current_scene = new_scene
	queue_free()
		
