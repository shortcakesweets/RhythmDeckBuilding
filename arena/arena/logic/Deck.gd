extends Node

var hand_pile : Array[Card] = [null, null, null, null, null, null]
var draw_pile : Array[Card] = []
var discard_pile : Array[Card] = []

func setup(character_data : CharacterData) -> void:
	var draw_pile = character_data.deck
	draw_pile.shuffle()
	reload()

# Draw card at specific idx. Returns the drawn card
#  this function is recommended to be private
func draw(idx : int) -> Card:
	if draw_pile.is_empty():
		shuffle()
	
	if hand_pile[idx] == null and not draw_pile.is_empty():
		hand_pile[idx] = draw_pile.pop_front()
		return hand_pile[idx]
	return null

# Draw card in first vacant slot. Returns the drawn card
func draw_in_vacant() -> Card:
	for idx in range(6):
		var card := draw(idx)
		if card != null:
			return card
	return null

# Discard's card at specific idx. Returns the drawn card
#  this function is recommended to be private
func discard(idx : int) -> Card:
	var card := hand_pile[idx]
	if card != null:
		discard_pile.append(card)
		hand_pile[idx] = null
	return card

func discard_all() -> Array[Card]:
	var cards : Array[Card] = []
	for idx in range(6):
		var card := discard(idx)
		if card != null:
			cards.append(card)
	return cards

# Discard all cards, draw [many] cards
func reload(many : int = 6) -> Array:
	var discarded_cards := discard_all()
	var drawn_cards : Array[Card] = []
	for idx in range(6):
		if many == 0:
			break
		var card := draw(idx)
		if card != null:
			many -= 1
			drawn_cards.append(card)
	return [discarded_cards, drawn_cards]

# specialized function of reload
func emergency_reload() -> Array:
	var arena := $"../.."
	var emergency_reload_many : int = arena.character_data.emergency_reload_many
	return reload(emergency_reload_many)

# shuffles discard pile and push at draw pile
func shuffle() -> void:
	discard_pile.shuffle()
	draw_pile.append_array(discard_pile)
	discard_pile.clear()
