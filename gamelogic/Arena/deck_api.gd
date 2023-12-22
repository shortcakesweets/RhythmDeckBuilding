extends Node

var deck_all : Array[int] = [0,0,0,0,0,1,1,1,1,1,2,3]
var discard_pile : Array[int]
var draw_pile : Array[int]

var shuffle_energy_max : int = 8
var shuffle_energy_threshold : int = 8
var shuffle_energy : int = 0
var emergency_shuffle_many : int = 3

@onready var cards := [$Card1, $Card2, $Card3, $Card4, $Card5, $Card6]

# Clear all hand, discards. Shuffle Draw pile, then draw 6 cards
func game_ready() -> void:
	for card in cards:
		card.animate_and_draw_card(-1)
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
	
	var card_id : int = draw_pile.pop_front()
	cards[card_index].animate_and_draw_card(card_id)

# Draw N cards. if full, stop draw
func draw_cards(many : int) -> void:
	for card_index in range(6):
		if many == 0:
			return
		if cards[card_index].card_id == -1:
			draw_card(card_index)
			many -= 1

# uses card at card_index, returns card_id
func use_card(card_index : int) -> int:
	var card_id = cards[card_index].card_id
	cards[card_index].animate_and_draw_card(-1)
	if card_id != -1:
		discard_pile.append(card_id)
	return card_id

# discards card at card_index. Doesn't use card effects
func discard_card(card_index : int) -> void:
	var card_id = cards[card_index].card_id
	cards[card_index].animate_and_draw_card(-1)
	if card_id != -1:
		discard_pile.append(card_id)

func is_hand_empty() -> bool:
	for index in range(6):
		if cards[index].card_id != -1:
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
		hand.append(cards[i].card_id)
	print("hand: ", hand)
