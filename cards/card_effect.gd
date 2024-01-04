extends Node
# API of card effects

func _get_player_entity_data() -> Node:
	return get_tree().get_nodes_in_group("character")[0].stats

func _get_enemy_entity_data_on_index(enemy_index : int) -> Enemy:
	return get_tree().get_nodes_in_group("enemies")[0].get_child(enemy_index).enemy_data as Enemy

func _get_deck_data() -> Node:
	return get_tree().get_nodes_in_group("deck")[0]

func damage_character(amount : int) -> void:
	var entity = _get_player_entity_data()
	if entity.defend >= amount:
		entity.defend -= amount
	else:
		amount -= entity.defend
		entity.defend = 0
		entity.hp -= amount
	entity.hp = clamp(entity.hp, 0, entity.max_hp)

func damage_character_pierce(amount : int) -> void:
	var entity = _get_player_entity_data()
	entity.hp -= amount
	entity.hp = clamp(entity.hp, 0, entity.max_hp)

func damage_enemy(index : int, amount : int) -> void:
	var entity = _get_enemy_entity_data_on_index(index)
	if entity == null:
		return
	
	if entity.defend >= amount:
		entity.defend -= amount
	else:
		amount -= entity.defend
		entity.defend = 0
		entity.hp -= amount
	entity.hp = clamp(entity.hp, 0, entity.max_hp)

func defend_character(amount : int) -> void:
	var entity = _get_player_entity_data()
	entity.defend += amount
	entity.defend = clamp(entity.defend, 0, 999)

func defend_enemy(index : int, amount : int) -> void:
	var entity = _get_enemy_entity_data_on_index(index)
	if entity == null:
		return
	entity.defend += amount
	entity.defend = clamp(entity.defend, 0, 999)

func knockback_enemy(index : int, amount : int) -> void:
	var entity = _get_enemy_entity_data_on_index(index)
	if entity == null:
		return
	
	pass

func draw_cards(many : int) -> void:
	var hand = _get_deck_data()
	hand.draw_cards(many)

func add_shuffle_energy(amount : int) -> void:
	var hand = _get_deck_data()
	hand.shuffle_energy += amount
	hand.shuffle_energy = clamp(hand.shuffle_energy, 0, hand.shuffle_energy_max)

##
func apply_card_effect(card : Card, target_index : int = -1) -> void:
	var effect : Dictionary = {}
	if card.is_upgraded:
		effect = card.upgraded_effect
	else:
		effect = card.effect
	
	for key in effect:
		var value = effect[key]
		if value == 0:
			continue
		
		match key:
			"Attack":
				damage_enemy(target_index,value)
			"Defend":
				defend_character(value)
			"Parry":
				pass
			"Knockback":
				knockback_enemy(target_index,value)
			"Charge":
				add_shuffle_energy(value)
			_:
				pass

func apply_enemy_effect(effect : Dictionary, enemy_index : int = -1) -> void:
	for key in effect:
		var value = effect[key]
		if value == 0:
			continue
		
		match key:
			"Attack":
				damage_character(value)
			"Defend":
				defend_enemy(enemy_index, value)
