extends Node

var curr_turn : int = 0
var parry_mode : bool = false
enum KEY_CODE {NO_INPUT = -2, DEFAULT = -1, RELOAD = 10, PARRY = 100}

# Turn logic
func turn(card_idx : int = -1) -> void:
	%Character_GUI.play_animation_once("Sword_Idle")
	
	var invoked_cards_used : Array[Card] = []
	var invoked_cards_parried : Array[Card] = []
	var invoked_cards_discarded : Array[Card] = []
	var invoked_cards_drawn : Array[Card] = []
	var invoked_cards_use_end : Array[Card] = []
	
	# 0. decay buffs
	var arena : Node = $"../.."
	var character_data : CharacterData = %Character.character_data
	for buff in character_data.buff_list:
		if buff.buff_count == 0:
			buff.on_decay_end(arena, character_data)
			character_data.buff_list.erase(buff)
		else:
			buff.on_decay(arena, character_data)
	
	# 1. Use card, calculate invoked_cards
	if card_idx == KEY_CODE.RELOAD:
		if %Deck.is_reload_available():
			var invoked_cards : Array = %Deck.reload()
			invoked_cards_discarded.append_array(invoked_cards[0])
			invoked_cards_drawn.append_array(invoked_cards[1])
		elif %Deck.is_emergency_reload_available():
			#print("emergency shuffle invoked")
			var invoked_cards : Array = %Deck.emergency_reload()
			invoked_cards_discarded.append_array(invoked_cards[0])
			invoked_cards_drawn.append_array(invoked_cards[1])
		else:
			# wrong input, take corresponding debuff
			pass
	if card_idx == KEY_CODE.PARRY:
		toggle_parry_mode()
	if 0 <= card_idx and card_idx < 6:
		#print(card_idx)
		var card : Card = null
		if not parry_mode:
			card = %Deck.use(card_idx)
			invoked_cards_used.append(card)
		else:
			card = %Deck.parry(card_idx)
			invoked_cards_parried.append(card)
		
		if card == null:
			card_idx = KEY_CODE.DEFAULT
	if card_idx == KEY_CODE.DEFAULT:
		# wrong input, take corresponding debuff
		pass
	if card_idx == KEY_CODE.NO_INPUT:
		# also wrong input, take corresponding debuff
		pass
	
	update_visuals()
	
	# 2. Card functions
	for card in invoked_cards_used:
		if card != null:
			card.on_use(arena)
			invoked_cards_use_end.append(card)
	for card in invoked_cards_parried:
		if card != null:
			card.on_parry(arena)
			invoked_cards_use_end.append(card)
	for card in invoked_cards_discarded:
		if card != null:
			card.on_discard(arena)
	for card in invoked_cards_drawn:
		if card != null:
			card.on_draw(arena)
	
	update_visuals()
	
	# 3. Enemy turn
	%Enemies.kill_enemy_with_zero_hp()
	for enemy in %Enemies.enemy_list:
		enemy.turn(arena)
	
	# 4. invoke used/parried card's on_use_end()
	for card in invoked_cards_use_end:
		if card != null:
			card.on_use_end(arena)
	
	# 5. invoke hand card's on_turn_end().
	var hand_pile : Array[Card] = %Deck.hand_pile
	for card in hand_pile:
		if card != null:
			card.on_turn_end(arena)
	
	# 6. invoke buff's on_turn_end() effects
	for buff in character_data.buff_list:
		if curr_turn != buff.applied_turn:
			buff.on_turn_end(arena, character_data)
	
	# last : increment turn count
	%Character.decay_defense()
	update_visuals()
	curr_turn += 1

func update_visuals() -> void:
	%Enemies_GUI.update_visuals()
	%Character_GUI.update_visuals()
	%Deck_GUI.update_visuals()
	%Energy_GUI.update_visuals()

func toggle_parry_mode() -> void:
	parry_mode = !parry_mode
	SoundManager.toggle_parry_distortion(parry_mode)

func turn_value(card : Card = null) -> void:
	pass

func turn_animation(card : Card = null) -> void:
	pass
