extends Node

var heal_sprite: Texture2D = load("res://resources/sprites/abilities/heal.png")
const heal_description: String = "Heal a friendly adjacent piece" 
const heal_name: String = "Heal"
const heal_cooldown: int = 4

var barricade_sprite: Texture2D = load("res://resources/sprites/abilities/shield.png")
const barricade_description: String = "Place a Wall within attack range"
const barricade_name: String = "Barricade"
const barricade_cooldown: int = 5

var reverse_sprite: Texture2D = load("res://resources/sprites/abilities/swirl.png")
const reverse_description: String = "Reverse this piece's direction"
const reverse_name: String = "Reverse"
const reverse_cooldown: int = 3

var inspire_sprite: Texture2D = load("res://resources/sprites/abilities/star.png")
const inspire_description: String = "Charge a friendly piece's ability cooldown"
const inspire_name: String = "Inspire"
const inspire_cooldown: int = 6

var swap_sprite: Texture2D = load("res://resources/sprites/abilities/wand.png")
const swap_description: String = "Swap positions with an adjacent friendly piece"
const swap_name: String = "Swap"
const swap_cooldown: int = 6

var buck_sprite: Texture2D = load("res://resources/sprites/abilities/sword.png")
const buck_description: String = "Deal 3 damage to an adjacent enemy piece (safe from counterattacks)"
const buck_name: String = "Buck"
const buck_cooldown: int = 5
const buck_damage: int = 3
