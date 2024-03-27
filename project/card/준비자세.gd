# 준비자세
# - 임시 힘 2를 얻는다.

static func on_use(arena : Node) -> void:
	var character_data : CharacterData = arena.get_node("%Character").character_data
	var buff : Buff = load("res://buff/임시_힘.tres").duplicate(true)
	buff.on_apply(arena, character_data, 3)
	
	var deck_node := arena.get_node("%Deck")
	deck_node.add_energy(-3)
