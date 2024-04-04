extends Card
class_name CardBasic

# This card template is used for cards that:
#  attacks enemy
#  defends
#  apply buff to self/enemy
#  discards
#  draws
#  exhausts

@export var base_damage : int = 6
@export var strength_multiplier : int = 1

@export var base_defense : int = 4

@export var self_buff : Buff = null
@export var self_buff_value : int = 0
@export var target_buff : Buff = null
@export var target_buff_value : int = 0

# Reminder : discard_all and exhaust_all cannot be both true
@export var discard_all : bool = false
@export var exhaust_all : bool = false
@export var draw : int = 0

# Override
func on_use(arena : Node) -> void:
	super.on_use(arena)
	_attack(arena)
	_defend(arena)
	_apply_buff(arena)
	_utility(arena)

#region private
func _attack(arena : Node) -> void:
	if base_damage == 0:
		return
	var enemies_node := arena.get_node("%Enemies")
	var enemy : Enemy = enemies_node.get_target()
	
	var character_data : CharacterData = arena.get_node("%Character").character_data
	var strength : int = character_data.get_buff_count("strength")
	if character_data.get_buff_count("attack_boost") > 0:
		strength += 2
	
	var damage : int = base_damage + strength * strength_multiplier
	if enemy != null:
		enemy.recieve_damage(arena, character_data, damage)

func _defend(arena : Node) -> void:
	if base_defense == 0:
		return
	var character_data : CharacterData = arena.get_node("%Character").character_data
	character_data.apply_defense(base_defense)

func _apply_buff(arena : Node) -> void:
	if self_buff != null:
		var character_data : CharacterData = arena.get_node("%Character").character_data
		character_data.apply_buff(arena, self_buff, self_buff_value)
	
	if target_buff != null:
		var enemies_node := arena.get_node("%Enemies")
		var enemy : Enemy = enemies_node.get_target()
		if enemy != null:
			enemy.apply_buff(arena, target_buff, target_buff_value)

func _utility(arena : Node) -> void:
	var deck_node : Node = arena.get_node("%Deck")
	if discard_all:
		deck_node._discard_all()
	elif exhaust_all:
		deck_node._exhaust_all()
	while draw > 0:
		if deck_node._draw_in_vacant() != null:
			draw -= 1
#endregion
