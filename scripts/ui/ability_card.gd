extends Control

@onready var ability_button: TextureButton = $VBoxContainer/AbilityIcon
@onready var ability_name: Label = $VBoxContainer/AbiltyName
@onready var description: Label = $VBoxContainer/AbilityDescription
@export var is_passive: bool
@export var is_primary: bool
@export var is_ultimate: bool

func _ready() -> void:
	ability_button.pressed.connect(_on_button_clicked)
	EventBus.overlay_drawn.connect(_draw)
	
func _on_button_clicked() -> void:
	if is_passive:
		return
	elif is_primary:
		GameState.selected_ability = GameState.selected_piece.primary
		EventBus.ability_selected.emit()
	elif is_ultimate:
		GameState.selected_ability = GameState.selected_piece.ultimate
		EventBus.ability_selected.emit()

func _draw() -> void:
	
	## This should never be null because this will only be called when a piece is selected
	var selected_piece: Piece = GameState.selected_piece
	
	#if is_passive:
		#ability_button.texture_normal = selected_piece.passive.sprite	
		#ability_name.text = selected_piece.passive.name	
		#description.text = selected_piece.passive.description	
	if is_primary:
		ability_button.texture_normal = selected_piece.primary.sprite
		ability_name.text = selected_piece.primary.name	
		description.text = selected_piece.primary.description
	#elif is_ultimate:
		#ability_button.texture_normal = selected_piece.ultimate.sprite	
		#ability_name.text = selected_piece.ultimate.name	
		#description.text = selected_piece.ultimate.description	
		
