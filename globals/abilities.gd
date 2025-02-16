class_name Abilities
extends Node

## Create two versions of each ability to manage the cooldowns for each side
static var black_heal_ability: HealAbility
static var black_barricade_ability: BarricadeAbility
static var black_reverse_ability: ReverseAbility
static var black_inspire_ability: InspireAbility
static var black_swap_ability: SwapAbility
static var black_buck_ability: BuckAbility

static var black_abilities: Array[Ability] = []

static var white_heal_ability: HealAbility
static var white_barricade_ability: BarricadeAbility
static var white_reverse_ability: ReverseAbility
static var white_inspire_ability: InspireAbility
static var white_swap_ability: SwapAbility
static var white_buck_ability: BuckAbility

static var white_abilities: Array[Ability] = []

func _ready():
	black_heal_ability = HealAbility.new()
	black_barricade_ability = BarricadeAbility.new()
	black_reverse_ability = ReverseAbility.new()
	black_inspire_ability = InspireAbility.new()
	black_swap_ability = SwapAbility.new()
	black_buck_ability = BuckAbility.new()
	black_abilities.append(black_heal_ability)
	black_abilities.append(black_barricade_ability)
	black_abilities.append(black_reverse_ability)
	black_abilities.append(black_inspire_ability)
	black_abilities.append(black_swap_ability)
	black_abilities.append(black_buck_ability)
	
	white_heal_ability = HealAbility.new()
	white_barricade_ability = BarricadeAbility.new()
	white_reverse_ability = ReverseAbility.new()
	white_inspire_ability = InspireAbility.new()
	white_swap_ability = SwapAbility.new()
	white_buck_ability = BuckAbility.new()
	white_abilities.append(white_heal_ability)
	white_abilities.append(white_barricade_ability)
	white_abilities.append(white_reverse_ability)
	white_abilities.append(white_inspire_ability)
	white_abilities.append(white_swap_ability)
	white_abilities.append(white_buck_ability)
