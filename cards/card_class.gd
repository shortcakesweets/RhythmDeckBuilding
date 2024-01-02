extends Resource
class_name Card
enum RARITY {BASE, COMMON, UNCOMMON, RARE}

@export var card_name := ""
@export var card_description := ""
@export var card_rarity : RARITY = RARITY.COMMON
@export var is_upgraded := false
@export var id : int = 0

@export var effect : Dictionary = {
	"Attack" : 0,
	"Defend" : 0,
	"Parry" : 0,
	"Knockback" : 0
}

@export var upgraded_effect : Dictionary = {
	"Attack" : 0,
	"Defend" : 0,
	"Parry" : 0,
	"Knockback" : 0
}
