extends Node

var enemy_list : Array[Enemy] = []

func set_enemy_list(raw_enemy_list : Array[Enemy]) -> void:
	enemy_list = raw_enemy_list.duplicate(true)

func get_current_enemy() -> Enemy:
	for enemy in enemy_list:
		if enemy != null:
			return enemy
	return null

func kill_enemy_with_zero_hp() -> void:
	for enemy in enemy_list:
		if enemy != null and enemy.hp == 0:
			enemy_list.erase(enemy)
