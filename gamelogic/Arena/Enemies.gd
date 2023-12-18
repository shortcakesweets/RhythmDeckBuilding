extends Node

func turns() -> Array:
	var effect_array := []
	for enemy in self.get_children():
		effect_array.append(enemy.turn())
	return effect_array
