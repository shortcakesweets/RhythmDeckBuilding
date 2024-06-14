extends Card
class_name BodySlam

@export var block_removal_ratio : float = 0.5

# Override
func on_use(arena : Node) -> void:
	super.on_use(arena)
	_attack(arena)

func _attack(arena : Node) -> void:
	var enemies_node := arena.get_node("%Enemies")
	var enemy : Enemy = enemies_node.get_target()
	
	var character_data : CharacterData = arena.get_node("%Character").character_data
	var strength : int = character_data.get_buff_count("strength")
	if character_data.get_buff_count("attack_boost") > 0:
		strength += 2
	var damage := character_data.defense + strength
	
	if enemy != null:
		enemy.recieve_damage(arena, character_data, damage)
	
	character_data.apply_defense(-int(character_data.defense * block_removal_ratio), false)
