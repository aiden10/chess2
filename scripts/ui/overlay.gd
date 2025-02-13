extends Control

@onready var portrait = $"VBoxContainer/Portrait"
@onready var piece_label = $"VBoxContainer/PieceType"
@onready var health_label = $"VBoxContainer/Health"
@onready var strength_label = $"VBoxContainer/Strength"
@onready var passive_card = $"VBoxContainer/PassiveCard"
@onready var primary_card = $"VBoxContainer/PrimaryCard"
@onready var ultimate_card = $"VBoxContainer/UltimateCard"

func _ready() -> void:
	## Make overlay hidden by default
	visible = false
	EventBus.piece_selected.connect(draw_overlay)
	
func draw_overlay():
	if GameState.selected_piece != null:
		visible = true
		piece_label.text = GameState.selected_piece.to_string()
		health_label.text = "HP: " + str(GameState.selected_piece.health)
		strength_label.text = "ATK: " + str(GameState.selected_piece.strength)
		portrait.texture = GameState.selected_piece.texture
		EventBus.overlay_drawn.emit()
		
	else:
		## Hide overlay
		visible = false
		piece_label.text = "Not selected"
	
