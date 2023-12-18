extends Node

var id_count : int = 0
var card_all : Array[Card] = []

func make_card(card_name : String, card_description : String, card_rarity : Card.RARITY):
	var new_card = Card.new(card_name, card_description, card_rarity, id_count)
	card_all.append(new_card)
	id_count += 1

func set_recent_card_effect(key : String, value, is_upgraded_effect : bool = false) -> void:
	if is_upgraded_effect:
		card_all.back().set_upgraded_effect(key, value)
	else:
		card_all.back().set_effect(key, value)

func _ready():
	make_card("Attack", "Attacks", Card.RARITY.COMMON)
	set_recent_card_effect("Attack", 6)
	make_card("Defend", "Defends", Card.RARITY.COMMON)
	set_recent_card_effect("Defend", 5)
	make_card("Parry", "Parries", Card.RARITY.UNCOMMON)
	set_recent_card_effect("Parry", 8)
	make_card("Swift Attack", "Attack and defend", Card.RARITY.UNCOMMON)
	set_recent_card_effect("Attack", 5)
	set_recent_card_effect("Defend", 5)
