extends Control

## Access the card's child nodes
@onready var ability_button: TextureButton = $VBoxContainer/AbilityIcon
@onready var ability_name: Label = $VBoxContainer/AbiltyName
@onready var description: Label = $VBoxContainer/AbilityDescription
@onready var status: Label = $VBoxContainer/AbilityStatus

@export var is_passive: bool
@export var is_primary: bool
@export var is_ultimate: bool

func _ready() -> void:
	description.autowrap_mode = TextServer.AUTOWRAP_WORD
	ability_button.pressed.connect(_on_button_clicked)
	EventBus.overlay_drawn.connect(_draw)

func _clear_card() -> void:
	ability_button.texture_normal = null
	ability_name.text = ""
	description.text = ""
	status.text = ""

func _on_button_clicked() -> void:
	## I either handle the pieces without abilities like this or I give the wall "dummy" abilities
	if is_passive:
		return
	
	elif is_primary:
		## Toggle ability selection
		if GameState.selected_ability == GameState.selected_piece.primary:
			GameState.selected_ability = null
		elif GameState.selected_piece.primary.cooldown == 0: ## Select the ability if its cooldown is over
			GameState.selected_ability = GameState.selected_piece.primary
		else: ## Cooldown not over, deselect ability
			GameState.selected_ability = null
		EventBus.ability_selected.emit()

	elif is_ultimate:
		## Toggle ability selection
		if GameState.selected_ability == GameState.selected_piece.ultimate:
			GameState.selected_ability = null
		else: ## Select the ability
			GameState.selected_ability = GameState.selected_piece.ultimate
		EventBus.ability_selected.emit()

func _draw() -> void:
	
	## This should never be null because this will only be called when a piece is selected
	var selected_piece: Piece = GameState.selected_piece

	## Walls don't have abilities so don't show any abilities
	if selected_piece.type == Piece.PieceType.WALL:
		_clear_card()
		return

	if is_passive:
		if selected_piece.passive:
			ability_button.texture_normal = selected_piece.passive.sprite	
			ability_name.text = selected_piece.passive.name	
			description.text = selected_piece.passive.description	
	
	elif is_primary:
		if selected_piece.primary:
			ability_button.texture_normal = selected_piece.primary.sprite
			ability_name.text = selected_piece.primary.name	
			description.text = selected_piece.primary.description
			if selected_piece.primary.cooldown == 0:
				ability_button.disabled = false
				ability_button.modulate = Color(1, 1, 1, 1.0)
				status.text = "Ready"
				ability_button.mouse_default_cursor_shape = CURSOR_POINTING_HAND
			## Ability on cooldown
			else:
				ability_button.disabled = true
				ability_button.modulate = Color(0.3, 0.3, 0.3, 0.5)
				var t = "turn" if selected_piece.primary.cooldown == 1 else "turns"
				status.text = "On cool down (" + str(selected_piece.primary.cooldown) + " " + t + " left)"
				ability_button.mouse_default_cursor_shape = CURSOR_ARROW
				
	elif is_ultimate:
		if selected_piece.ultimate:
			ability_button.texture_normal = selected_piece.ultimate.sprite	
			ability_name.text = selected_piece.ultimate.name	
			description.text = selected_piece.ultimate.description	
			if selected_piece.ultimate.used:
				ability_button.disabled = true
				ability_button.modulate = Color(0.3, 0.3, 0.3, 0.5)
				status.text = "Depleted"
				ability_button.mouse_default_cursor_shape = CURSOR_ARROW

			else:
				status.text = "Ready"
				ability_button.mouse_default_cursor_shape = CURSOR_POINTING_HAND

		
