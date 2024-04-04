extends Buff
class_name BuffStunned

# Override
func is_applyable(_arena, entity : Entity) -> bool:
	return entity.get_buff_count(buff_name) == 0

# Override
func on_apply(_arena, entity : Entity) -> void:
	if entity is Enemy:
		# regarding delay, buff_count + 1 is applied
		entity.turn_counter += buff_count + 1
		buff_count = buff_count * 2 + 1 # resistance
