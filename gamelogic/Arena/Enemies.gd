extends Node

@export var enemy_spawn_info : Array[Enemy] = []
var enemy_waiting_queue : Array[Enemy] = []
@onready var enemy_slot = [$Enemy1, $Enemy2, $Enemy3]

func turns() -> Array:
	var effect_array := []
	for enemy in self.get_children():
		effect_array.append(enemy.turn())
	return effect_array

# if no vacant slot, return -1
func get_vacant_slot() -> int:
	for i in range(enemy_slot.size()):
		if enemy_slot[i].enemy_data == null:
			return i
	return -1

# spawns if available
func spawn(curr_turn : int) -> void:
	var vacant_index = get_vacant_slot()
	if curr_turn < enemy_spawn_info.size():
		#print(enemy_spawn_info[curr_turn])
		if enemy_spawn_info[curr_turn] != null:
			enemy_waiting_queue.push_back(enemy_spawn_info[curr_turn])
	if vacant_index != -1 and not enemy_waiting_queue.is_empty():
		enemy_slot[vacant_index].set_values_from_resource(enemy_waiting_queue.pop_front())
