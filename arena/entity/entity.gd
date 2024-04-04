extends Resource
class_name Entity

@export var max_hp : int = 100
@export var hp : int = 100
var defense : int = 0

@export var buff_list : Array[Buff] = []

# Character functions
func recieve_damage(arena, attacker : Entity, damage : int):
	if damage <= defense:
		apply_defense(-damage)
	else:
		damage -= defense
		apply_defense(-defense)
		hp = clamp(hp - damage, 0, 999)

func apply_defense(value : int) -> void:
	defense = clamp(defense + value, 0, 999)

func is_dead() -> bool:
	return hp == 0

#region WIP
func apply_buff(arena, buff : Buff, value : int) -> void:
	if buff.is_applyable(arena, self):
		# check if buff is already in self
		var pre_buff := _get_buff(buff.buff_name)
		if pre_buff == null:
			buff = buff.duplicate(true) as Buff
			buff.buff_count = value
			buff_list.append(buff)
			buff.on_apply(arena, self)
		else:
			pre_buff.buff_count += value
			pre_buff.on_apply(arena, self)

func decay_buffs(arena) -> void:
	for buff in buff_list:
		if buff.decay(arena, self):
			buff_list.erase(buff)

func _get_buff(buff_name : String) -> Buff:
	for buff in buff_list:
		if buff.buff_name == buff_name:
			return buff
	return null

func get_buff_count(buff_name : String) -> int:
	var buff := _get_buff(buff_name)
	if buff != null:
		return buff.buff_count
	return 0
#endregion
