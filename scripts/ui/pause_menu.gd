extends CenterContainer

@onready var background: ColorRect = $Background
@onready var unpause_button: Button = $VBoxContainer/UnpauseButton
@onready var quit_button: Button = $VBoxContainer/QuitButton
@onready var tween: Tween

@export var transition_speed: float = 0.3
@export var main_menu_scene: PackedScene

func _ready() -> void:
	get_tree().root.size_changed.connect(_resize)
	unpause_button.pressed.connect(_unpause)
	quit_button.pressed.connect(return_to_menu)
	process_mode = Node.PROCESS_MODE_ALWAYS
	_resize()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):  # ESC key
		_unpause()
		
func _unpause() -> void:
	tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, transition_speed)
	await tween.finished
	get_tree().paused = false
	queue_free()
	
func return_to_menu() -> void:
	get_tree().paused = false
	
	if main_menu_scene:
		# Instance the main menu first
		var menu_instance = main_menu_scene.instantiate()
		
		# Get the root node
		var root = get_tree().root
		
		# Get the current game scene (should be the second to last child of root)
		var current_scene = get_tree().current_scene
		
		# Add the menu instance to root
		root.add_child(menu_instance)
		
		# Update the current scene reference
		get_tree().current_scene = menu_instance
		
		# Clean up
		queue_free()  # Remove pause menu first
		if is_instance_valid(current_scene):
			current_scene.queue_free()  # Then remove the game scene
					
func _resize() -> void:
	var viewport_size = get_viewport_rect().size
	
	var base_button_size = Vector2(120, 40)
	var button_scale = clamp(min(viewport_size.x, viewport_size.y) / 720.0, 0.5, 2.0)
	quit_button.custom_minimum_size = base_button_size * button_scale
	unpause_button.custom_minimum_size = base_button_size * button_scale
	
	background.custom_minimum_size = Vector2(viewport_size.x - (viewport_size.x / 2), viewport_size.y - (viewport_size.y / 2))
