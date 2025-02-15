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
