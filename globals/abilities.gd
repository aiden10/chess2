class_name Abilities
extends Node

static var heal_ability: HealAbility
static var barricade_ability: BarricadeAbility

func _ready():
	heal_ability = HealAbility.new()
	barricade_ability = BarricadeAbility.new()
