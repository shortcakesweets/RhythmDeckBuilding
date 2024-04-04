extends CardBasic
class_name CardSummon

# This card template can Summon cards
# summon_here only works when there is only 1 summon card.
# this makes the card to summon at this card's place
@export var summon : Array[Card] = []
@export var summon_here : bool = true

# Override
func on_use(arena : Node) -> void:
	var deck_node := arena.get_node("%Deck") as Node
	var this_idx = deck_node._get_card_idx(self)
	super.on_use(arena)
	
	# since this card summons something, this_idx should be vacant.
	if summon.size() == 1 and summon_here:
		deck_node._summon(summon[0], this_idx)
	else:
		for card in summon:
			deck_node._summon_in_vacant(card)
