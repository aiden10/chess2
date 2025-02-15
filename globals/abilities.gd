class_name Abilities
extends Node

static var heal_ability: HealAbility
static var barricade_ability: BarricadeAbility
static var reverse_ability: ReverseAbility

func _ready():
	heal_ability = HealAbility.new()
	barricade_ability = BarricadeAbility.new()
	reverse_ability = ReverseAbility.new()
