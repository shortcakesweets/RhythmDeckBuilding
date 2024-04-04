# sample_3
# - 샘플 버프 2를 얻는다.

static func on_use(arena : Node) -> void:
	var character_data : CharacterData = arena.get_node("%Character").character_data
	var buff : Buff = load("res://buff/sample_buff.tres").duplicate(true)
	buff.on_apply(arena, character_data, 2)
	
	var deck_node := arena.get_node("%Deck")
	deck_node.add_energy(-2)
