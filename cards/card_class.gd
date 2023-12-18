class_name Card
enum RARITY {COMMON, UNCOMMON, RARE}

var card_name := ""
var card_description := ""
var card_rarity : RARITY = RARITY.COMMON
var is_upgraded := false
var id : int = 0

var effect : Dictionary = {
	"Attack" : 0,
	"Defend" : 0,
	"Parry" : 0,
	"Knockback" : 0
}

var upgraded_effect : Dictionary = {
	"Attack" : 0,
	"Defend" : 0,
	"Parry" : 0,
	"Knockback" : 0
}

func set_effect(key : String, value):
	effect[key] = value

func set_upgraded_effect(key : String, value):
	upgraded_effect[key] = value

func _init(card_name_ : String, card_description_ : String, card_rarity_ : RARITY, id_ : int):
	card_name = card_name_
	card_description = card_description_
	card_rarity = card_rarity_
	id = id_
	is_upgraded = false
