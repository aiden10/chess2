extends CenterContainer

@onready var container: VBoxContainer = $VBoxContainer
@onready var winner_label: Label = $VBoxContainer/WinnerLabel
@onready var restart_button: Button = $VBoxContainer/RestartButton
@onready var background: ColorRect = $Background

var winner: String = "White"

func _ready() -> void:
	get_tree().root.size_changed.connect(_resize)
	winner_label.text = winner + " Wins"
	winner_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	winner_label.add_theme_font_size_override("font_size", 32)
	restart_button.custom_minimum_size = Vector2(120, 40)
	restart_button.pressed.connect(_restart_game)
	_resize()

func _resize() -> void:
	var viewport_size = get_viewport_rect().size
	
	# Scale the font size based on screen width.
	var base_font_size = 32
	var scale_factor = clamp(viewport_size.x / 1024.0, 0.5, 2.0)
	var new_font_size = int(base_font_size * scale_factor)
	winner_label.add_theme_font_size_override("font_size", new_font_size)
	
	# Scale the button size based on screen dimensions.
	var base_button_size = Vector2(120, 40)
	var button_scale = clamp(min(viewport_size.x, viewport_size.y) / 720.0, 0.5, 2.0)
	restart_button.custom_minimum_size = base_button_size * button_scale
	
	background.custom_minimum_size = Vector2(viewport_size.x - (viewport_size.x / 2), viewport_size.y - (viewport_size.y / 2))
	
func _restart_game() -> void:
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
