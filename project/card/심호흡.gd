# sample_0
# - 사용시 에너지 3을 얻는다.

static func on_use(arena : Node) -> void:
	var deck_node := arena.get_node("%Deck")
	deck_node.add_energy(3)
