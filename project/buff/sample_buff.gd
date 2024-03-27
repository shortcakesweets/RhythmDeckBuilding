
# n턴동안 추가 드로우를 1장씩 합니다.

static func on_turn_end(arena : Node, target : Resource) -> void:
	var deck_node := arena.get_node("%Deck")
	var card : Card = deck_node.draw_in_vacant()
	
	if card != null:
		card.on_draw(arena)
