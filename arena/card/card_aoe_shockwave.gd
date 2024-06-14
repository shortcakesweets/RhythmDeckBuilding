extends Card
class_name CardAOEShockWave

@export var target_buff : Buff
#@export var target_buff_value : int = 0

# Override
func on_use(arena : Node) -> void:
	super.on_use(arena)
	_apply_buff(arena)

# Private
func _apply_buff(arena : Node) -> void:
	if target_buff != null:
		var enemies_node := arena.get_node("%Enemies")
		var enemy_list : Array[Enemy] = enemies_node.get_all_target()
		for enemy in enemy_list:
			if enemy != null:
				enemy.apply_buff(arena, target_buff, used_energy)
