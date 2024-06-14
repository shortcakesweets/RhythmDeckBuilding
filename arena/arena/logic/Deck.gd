extends Node

var hand_pile : Array[Card] = [null, null, null, null, null, null]
var draw_pile : Array[Card] = []
var discard_pile : Array[Card] = []
var exhaust_pile : Array[Card] = []

func setup(character_data : CharacterData) -> void:
	draw_pile = character_data.deck
	draw_pile.shuffle()
	_reload()
	
	var arena := $"../.."
	%Deck_GUI.update_visuals(arena)

# Reloads hand regarding energy status
func reload_regarding_energy() -> bool:
	var reload_success : bool = true
	var character_data : CharacterData = %Character.character_data
	if _is_reload_available():
		character_data.apply_energy(-character_data.reload_threshold)
		_reload()
	elif _is_emergency_reload_available():
		_emergency_reload()
	else:
		reload_success = false
	
	if reload_success:
		var arena := $"../.."
		%Deck_GUI.update_visuals(arena)
	else:
		# animate reload failed animation
		pass
	return reload_success

# use card in hand.
func use_card(idx : int) -> bool:
	var arena := $"../.."
	var card := hand_pile[idx]
	if card != null and card.is_available(arena):
		card.on_use(arena)
		#card.on_use_end(arena)
		#%Deck_GUI.update_visuals(arena)
		return true
	else:
		return false

func on_turn_end() -> void:
	var arena := $"../.."
	for idx in range(6):
		var card := hand_pile[idx]
		if card == null:
			continue
		card.on_turn_end(arena)

#region Helper functions
# Draw card at specific idx. Returns the drawn card
#  this function is recommended to be private
func _draw(idx : int) -> Card:
	var arena := $"../.."
	if draw_pile.is_empty():
		_shuffle()
	
	if hand_pile[idx] == null and not draw_pile.is_empty():
		var card := draw_pile.pop_front() as Card
		hand_pile[idx] = card
		card.on_draw(arena)
		return card
	return null

# Draw card in first vacant slot. Returns the drawn card
func _draw_in_vacant() -> Card:
	for idx in range(6):
		var card := _draw(idx)
		if card != null:
			return card
	return null

# Summons card at idx, returns the summoned card
func _summon(card : Card, idx : int) -> Card:
	card = card.duplicate(true)
	if hand_pile[idx] == null:
		hand_pile[idx] = card
		return card
	return null

func _summon_in_vacant(card : Card) -> Card:
	for idx in range(6):
		if _summon(card, idx) != null:
			return card
	return null

# Discard's card at specific idx. Returns the drawn card
#  this function is recommended to be private
func _discard(idx : int) -> Card:
	var arena := $"../.."
	var card := hand_pile[idx]
	if card != null:
		card.on_discard(arena)
		discard_pile.append(card)
		hand_pile[idx] = null
	return card

func _discard_all() -> Array[Card]:
	var cards : Array[Card] = []
	for idx in range(6):
		var card := _discard(idx)
		if card != null:
			cards.append(card)
	return cards

# exhausts card at specific idx. Returns the exhausted card
func _exhaust(idx : int) -> Card:
	var arena := $"../.."
	var card := hand_pile[idx]
	if card != null:
		card.on_exhaust(arena)
		hand_pile[idx] = null
		exhaust_pile.append(card)
	return card

func _exhaust_all() -> Array[Card]:
	var cards : Array[Card] = []
	for idx in range(6):
		var card := _exhaust(idx)
		if card != null:
			cards.append(card)
	return cards

# Discard all cards, draw [many] cards
func _reload(many : int = 6) -> Array:
	var discarded_cards := _discard_all()
	var drawn_cards : Array[Card] = []
	for idx in range(6):
		if many == 0:
			break
		var card := _draw(idx)
		if card != null:
			many -= 1
			drawn_cards.append(card)
	return [discarded_cards, drawn_cards]

# specialized function of reload
func _emergency_reload() -> Array:
	var character_data : CharacterData = %Character.character_data
	var emergency_reload_many : int = character_data.emergency_reload_many
	return _reload(emergency_reload_many)

# shuffles discard pile and push at draw pile
func _shuffle() -> void:
	discard_pile.shuffle()
	draw_pile.append_array(discard_pile)
	discard_pile.clear()

func _is_reload_available() -> bool:
	var character_data := %Character.character_data as CharacterData
	return character_data.energy >= character_data.reload_threshold

func _is_emergency_reload_available() -> bool:
	var character_data := %Character.character_data as CharacterData
	for idx in range(6):
		var card := hand_pile[idx]
		if card != null and card.card_energy <= character_data.energy:
			return false
	return true

func _get_card_idx(card : Card) -> int:
	for idx in range(6):
		if hand_pile[idx] == card:
			return idx
	return -1
#endregion

# Debug function
func print_pile() -> void:
	print("hand_pile:")
	print(hand_pile)
	print("draw_pile, discard_pile:")
	print(draw_pile, "\n", discard_pile)
