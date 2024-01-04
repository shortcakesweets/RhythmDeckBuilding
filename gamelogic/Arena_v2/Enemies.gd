extends CanvasLayer

@export var enemy_spawn_info : Array[Enemy] = []
var enemy_waiting_queue : Array[Enemy] = []
@onready var enemy_slot = [$Enemy1, $Enemy2, $Enemy3]

func turns() -> void:
	# Enemies will get effect on this step
	var enemy_entity_array = self.get_children()
	for enemy_index in range(enemy_entity_array.size()):
		var enemy = enemy_entity_array[enemy_index]
		var effect : Dictionary = enemy.turn()
		CardEffect.apply_enemy_effect(effect, enemy_index)
		
		# Debug option
		if not effect.is_empty():
			print(enemy_index, " ", effect)

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
		#enemy_slot[vacant_index].set_values_from_resource(enemy_waiting_queue.pop_front())
		enemy_slot[vacant_index].spawn(enemy_waiting_queue.pop_front())
