extends Node

var deck_all : Array[Card] = []
var discard_pile : Array[Card]
var draw_pile : Array[Card]

var shuffle_energy_max : int = 8
var shuffle_energy_threshold : int = 8
var shuffle_energy : int = 0
var emergency_shuffle_many : int = 3

@onready var cards := [$Card1, $Card2, $Card3, $Card4, $Card5, $Card6]

func set_base_cards_on_deck_all() -> void:
	var base_attack : Card = preload("res://cards/card_resource/Basic_Attack.tres")
	var base_defend : Card = preload("res://cards/card_resource/Basic_Defend.tres")
	var base_parry : Card  = preload("res://cards/card_resource/Basic_Parry.tres")
	var base_swiftattack : Card = preload("res://cards/card_resource/Basic_SwiftAttack.tres")
	for _i in range(5):
		deck_all.append(base_attack)
		deck_all.append(base_defend)
	deck_all.append(base_parry)
	deck_all.append(base_swiftattack)

func _ready() -> void:
	set_base_cards_on_deck_all()

# Clear all hand, discards. Shuffle Draw pile, then draw 6 cards
func game_ready() -> void:
	for card in cards:
		card.animate_and_draw_card()
	discard_pile.clear()
	draw_pile.clear()
	
	draw_pile = deck_all.duplicate(true)
	shuffle_draw_pile()
	draw_cards(6)

# Shuffle draw pile
func shuffle_draw_pile() -> void:
	draw_pile.shuffle()

# Shuffle discard pile, push to draw pile
func discard_to_draw_pile() -> void:
	discard_pile.shuffle()
	draw_pile.append_array(discard_pile)
	discard_pile.clear()

# Draw card at "card_index" point
func draw_card(card_index : int) -> void:
	if draw_pile.is_empty():
		discard_to_draw_pile()
	if draw_pile.is_empty(): # if it's still empty
		return
	
	var card_resource : Card = draw_pile.pop_front()
	cards[card_index].animate_and_draw_card(card_resource)

# Draw N cards. if full, stop draw
func draw_cards(many : int) -> void:
	for card_index in range(6):
		if many == 0:
			return
		if cards[card_index].card_resource_raw == null:
			draw_card(card_index)
			many -= 1

# uses card at card_index, returns card resource
func use_card(card_index : int) -> Card:
	var card_resource : Card = cards[card_index].card_resource_raw
	cards[card_index].animate_and_draw_card()
	if card_resource != null:
		discard_pile.append(card_resource)
	return card_resource

# discards card at card_index. Doesn't use card effects
func discard_card(card_index : int) -> void:
	var card_resource = cards[card_index].card_resource_raw
	cards[card_index].animate_and_draw_card()
	if card_resource != null:
		discard_pile.append(card_resource)

func is_hand_empty() -> bool:
	for index in range(6):
		if cards[index].card_resource_raw != null:
			return false
	return true

# Use shuffle(Skill). If failed, returns false.
func use_shuffle() -> bool:
	if shuffle_energy >= shuffle_energy_threshold:
		shuffle_energy -= shuffle_energy_threshold
		for index in range(6):
			discard_card(index)
		draw_cards(6)
		return true
	elif is_hand_empty():
		draw_cards(emergency_shuffle_many)
		return true
	return false

# debug option
func _on_game_ready_pressed():
	game_ready()

func _on_show_deck_on_console_pressed():
	print("deck_all: ", deck_all)
	print("draw_pile: ", draw_pile)
	print("discard_pile: ", discard_pile)
	var hand := []
	for i in range(6):
		if cards[i].card_resource_raw != null:
			hand.append(cards[i].card_resource_raw.card_name)
		else:
			hand.append("NONE")
	print("hand: ", hand)
