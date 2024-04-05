extends Enemy
class_name EnemyBasic

# Repeats only 1 type of action

@export var action_name : String = ""
@export var action_icon : CompressedTexture2D = null
@export var action_animation: String = ""
@export var action_description : String = ""
@export var action_period : int = 4

@export var base_damage : int = 0
@export var base_defense : int = 0

@export var self_buff : Buff = null
@export var self_buff_value : int = 0
@export var target_buff : Buff = null
@export var target_buff_value : int = 0

# Override
func turn(arena) -> void:
	super.turn(arena)
	if is_dead():
		turn_counter = 0
		return
	turn_counter -= 1
	if turn_counter == 0:
		current_animation = action_animation
		_action(arena)
		turn_counter = action_period
	current_icon = action_icon

func _action(arena) -> void:
	var character_data : CharacterData = arena.get_node("%Character").character_data
	character_data.recieve_damage(arena, self, base_damage)
	apply_defense(base_defense)
	
	if self_buff != null:
		apply_buff(arena, self_buff, self_buff_value)
	if target_buff != null:
		character_data.apply_buff(arena, target_buff, target_buff_value)
