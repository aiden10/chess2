extends TextureButton

@export var paused_scene: PackedScene
@export var target_size: Vector2

func _ready() -> void:
	get_tree().root.size_changed.connect(_resize)
	self.texture_normal = load("res://resources/sprites/pause.png")
	self.pressed.connect(_pause)
	# Set custom minimum size instead of scaling
	custom_minimum_size = target_size
	_resize()
	
func _pause() -> void:
	if paused_scene:
		var pause_instance = paused_scene.instantiate()
		get_tree().root.add_child(pause_instance)
		get_tree().paused = true

func _resize() -> void:
	var viewport_size = get_viewport_rect().size
	# Make size relative to viewport height
	var new_size = Vector2.ONE * (viewport_size.y * 0.15) 
	custom_minimum_size = new_size
	
	# Position relative to viewport
	var padding = Vector2(
		viewport_size.x * 0.05,  # 5% of viewport width
		viewport_size.y * 0.05   # 5% of viewport height
	)
	position = Vector2(
		viewport_size.x - new_size.x - padding.x,
		padding.y
	)
