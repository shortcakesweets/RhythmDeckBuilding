extends Node
# API of card effects

func damage_character(amount : int) -> void:
	var entity = get_node("%Character")
	if entity.defend >= amount:
		entity.defend -= amount
	else:
		amount -= entity.defend
		entity.defend = 0
		entity.hp -= amount
	entity.hp = clamp(entity.hp, 0, entity.max_hp)

func damage_character_pierce(amount : int) -> void:
	var entity = get_node("%Character")
	entity.hp -= amount
	entity.hp = clamp(entity.hp, 0, entity.max_hp)

func damage_enemy(index : int, amount : int) -> void:
	var entity = get_node("%Enemies").get_child(index).enemy_data as Enemy
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
	var entity = get_node("%Character")
	entity.defend += amount
	entity.defend = clamp(entity.defend, 0, 999)

func draw_cards(many : int) -> void:
	get_node("%hand").draw_cards(many)

func add_shuffle_energy(amount : int) -> void:
	var hand = get_node("%hand")
	hand.shuffle_energy += amount
	hand.shuffle_energy = clamp(hand.shuffle_energy, 0, hand.shuffle_energy_max)
