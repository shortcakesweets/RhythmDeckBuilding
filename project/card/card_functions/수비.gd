# sample_0
# - 방어도 2를 얻는다

static func on_use(arena : Node) -> void:
	var character_node := arena.get_node("%Character")
	var character_data : CharacterData = character_node.character_data
	if character_data == null:
		return
	character_node.add_defense(4)
