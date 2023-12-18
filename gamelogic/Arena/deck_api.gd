extends Node

var deck_all : Array[int] = [0,0,0,0,0,1,1,1,1,1,2,3]
var discard_pile : Array[int]
var draw_pile : Array[int]

@onready var cards := [$Card1, $Card2, $Card3, $Card4, $Card5, $Card6]

func game_ready() -> void:
	for card in cards:
		card.animate_and_draw_card(-1)
	discard_pile.clear()
	draw_pile.clear()
	
	draw_pile = deck_all.duplicate(true)
	shuffle_draw_pile()
	draw_cards()

func shuffle_draw_pile() -> void:
	draw_pile.shuffle()

func discard_to_draw_pile() -> void:
	discard_pile.shuffle()
	draw_pile.append_array(discard_pile)
	discard_pile.clear()

func draw_card(card_index : int) -> void:
	if draw_pile.is_empty():
		discard_to_draw_pile()
	if draw_pile.is_empty(): # if it's still empty
		return
	
	var card_id : int = draw_pile.pop_front()
	cards[card_index].animate_and_draw_card(card_id)

func draw_cards() -> void:
	for card_index in range(6):
		if cards[card_index].card_id == -1:
			draw_card(card_index)

func use_card(card_index : int) -> int:
	var card_id = cards[card_index].card_id
	cards[card_index].animate_and_draw_card(-1)
	discard_pile.append(card_id)
	return card_id

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
