# sample_1
#  피해를 6 줍니다.

static func on_use(arena : Node) -> void:
	var enemy : Enemy = arena.get_node("%Enemies").get_current_enemy()
	var character_data : CharacterData = arena.get_node("%Character").character_data
	if enemy == null:
		return
	
	var damage := 6
	if character_data.has_buff("임시 힘"):
		damage += 2
	
	enemy.recieve_attack(damage)
