class_name Abilities
extends Node

static var heal_ability: HealAbility

func _ready():
	heal_ability = HealAbility.new()
