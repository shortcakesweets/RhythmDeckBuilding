extends Enemy
class_name Skeleton

# Specialized enemy skeleton with coutner attacks

@export var action_name : String = ""
@export var action_icon : CompressedTexture2D = null
@export var action_animation: String = ""
@export var action_description : String = ""
@export var action_period : int = 4

@export var counter_action_name : String = ""
@export var counter_action_icon : CompressedTexture2D = null
@export var counter_action_animation : String = ""
@export var counter_action_idle_animation : String = ""
@export var counter_action_description : String = ""
@export var counter_action_period : int = 4

@export var current_action : String = ""

@export var base_damage : int = 0
@export var base_defense : int = 0
@export var counter_damage : int = 0

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
		match current_action:
			action_name:
				_action_base(arena)
			counter_action_name:
				_action_counter(arena)
	elif current_action == counter_action_name:
		current_animation = counter_action_idle_animation

# Override
func recieve_damage(arena, attacker : Entity, damage : int) -> void:
	super.recieve_damage(arena, attacker, damage)
	
	if current_action == counter_action_name:
		turn_counter = 1

#region private
func _action_base(arena) -> void:
	var character_data : CharacterData = arena.get_node("%Character").character_data
	character_data.recieve_damage(arena, self, base_damage)
	apply_defense(base_defense)
	
	if self_buff != null:
		apply_buff(arena, self_buff, self_buff_value)
	if target_buff != null:
		character_data.apply_buff(arena, target_buff, target_buff_value)
	
	current_animation = action_animation
	current_action = counter_action_name
	turn_counter = counter_action_period

func _action_counter(arena) -> void:
	var character_data : CharacterData = arena.get_node("%Character").character_data
	character_data.recieve_damage(arena, self, counter_damage)
	
	current_animation = counter_action_animation
	current_action = action_name
	turn_counter = action_period
#endregion

