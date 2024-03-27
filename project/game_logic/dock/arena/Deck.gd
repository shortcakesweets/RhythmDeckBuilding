extends Node

var hand_pile : Array[Card] = [null, null, null, null, null, null]
var draw_pile : Array[Card] = []
var discard_pile : Array[Card] = []

var energy : int = 0
var reload_threshold : int = 8

@onready var arena : Node = $"../.."

func setup_deck(character_data : CharacterData) -> void:
	draw_pile = character_data.deck.duplicate(true)
	draw_pile.shuffle()
	draw_all()
	%Deck_GUI.update_visuals()
	arena = $"../.."

# the following functions does not invoke card functions.
# (card functions are invoked in Turn)
# these only make card movements + animations + sfx.
# validity are checked in those functions.

func use(idx : int) -> Card:
	var card : Card = hand_pile[idx]
	if card != null and card.is_available(arena):
		hand_pile[idx] = null
		SoundManager.play_sfx(card.use_sfx)
		return card
	return null

func parry(idx : int) -> Card:
	var card : Card = hand_pile[idx]
	if card != null and card.is_available(arena):
		hand_pile[idx] = null
		return card
	return null

func discard(idx : int) -> Card:
	var card : Card = hand_pile[idx]
	if card != null:
		discard_pile.append(hand_pile[idx])
		hand_pile[idx] = null
		return card
	return null

func exhaust(idx : int) -> Card:
	var card : Card = hand_pile[idx]
	if card != null:
		hand_pile[idx] = null
		return card
	return null

func draw(idx : int) -> Card:
	if draw_pile.is_empty():
		shuffle()
	
	if hand_pile[idx] == null and not draw_pile.is_empty():
		hand_pile[idx] = draw_pile.pop_front()
		return hand_pile[idx]
	return null

func draw_in_vacant() -> Card:
	for idx in range(6):
		var card := draw(idx)
		if card != null:
			return card
	return null

func shuffle() -> void:
	discard_pile.shuffle()
	draw_pile.append_array(discard_pile)
	discard_pile.clear()

func discard_all() -> Array[Card]:
	var invoked_cards : Array[Card] = []
	for idx in range(6):
		invoked_cards.append(discard(idx))
	return invoked_cards

func draw_all() -> Array[Card]:
	var invoked_cards : Array[Card] = []
	for idx in range(6):
		invoked_cards.append(draw(idx))
	return invoked_cards

func reload() -> Array:
	if not is_reload_available():
		return []
	
	SoundManager.play_sfx("reload")
	energy = clamp(energy - reload_threshold, 0, 12)
	var invoked_cards_discarded : Array[Card] = []
	var invoked_cards_drawn : Array[Card] = []
	invoked_cards_discarded.append_array(discard_all())
	invoked_cards_drawn.append_array(draw_all())
	return [invoked_cards_discarded, invoked_cards_drawn]

func emergency_reload() -> Array:
	if not is_emergency_reload_available():
		return []
	
	SoundManager.play_sfx("reload")
	var invoked_cards_discarded : Array[Card] = []
	var invoked_cards_drawn : Array[Card] = []
	invoked_cards_discarded.append_array(discard_all())
	var count := 0
	for idx in range(6):
		var card := draw(idx)
		if card != null:
			count += 1
			invoked_cards_drawn.append(card)
		if count == 3:
			break
	return [invoked_cards_discarded, invoked_cards_drawn]

func is_reload_available() -> bool:
	return energy >= reload_threshold

func is_emergency_reload_available() -> bool:
	if reload_threshold <= energy:
		return false
	
	for idx in range(6):
		if hand_pile[idx] != null and hand_pile[idx].card_energy <= energy:
				return false
	return true

func add_energy(amount : int) -> void:
	var character_data : CharacterData = %Character.character_data
	energy = clamp(energy + amount, 0, character_data.max_energy)
