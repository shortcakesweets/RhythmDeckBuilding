extends Card
class_name CardSpecialConsume

# Specialized

# Override
func on_use(arena : Node) -> void:
	var character_data : CharacterData = arena.get_node("%Character").character_data
	var deck_node : Node = arena.get_node("%Deck")
	if not card_energy_X:
		character_data.apply_energy(-card_energy)
	else:
		used_energy = character_data.energy
		character_data.apply_energy(-character_data.energy)
	
	card_energy_refill = deck_node.exhaust_pile.size()
	character_data.apply_energy(card_energy_refill)
	
	# animation update
	character_data.current_animation = character_animation
	
	_on_use_end(arena)
