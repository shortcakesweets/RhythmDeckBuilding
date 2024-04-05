extends Node

var enemy_list : Array[Enemy] = []

func setup(wave : Wave) -> void:
	enemy_list = wave.enemy_list.duplicate(true)
	%Enemies_GUI.update_visuals(true)

func get_target() -> Enemy:
	for enemy in enemy_list:
		if not enemy.is_dead():
			return enemy
	return null

# Deprecated
#func kill_enemy_with_0_hp() -> void:
	#for enemy in enemy_list:
		#if enemy.is_dead():
			#pass

func turn_all() -> void:
	#kill_enemy_with_0_hp()
	var arena = $"../.."
	for enemy in enemy_list:
		enemy.turn(arena)
	
	%Enemies_GUI.update_visuals()

func decay_buffs_all(arena) -> void:
	for enemy in enemy_list:
		enemy.decay_buffs(arena)
