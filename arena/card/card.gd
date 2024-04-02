extends Resource
class_name Card

enum RARITY{
	BASE, COMMON, UNCOMMON, RARE, SPECIAL
}

@export var card_name : String = ""
@export var card_rarity : RARITY = RARITY.BASE
@export var upgrade : Card = null

@export var card_energy : int = 1
@export var card_illust : CompressedTexture2D = null

@export var description := ""

@export var character_animation := ""
@export var use_sfx : AudioStreamOggVorbis = null

func is_available(arena : Node) -> bool:
	var curr_energy : int = arena.character_data.energy
	return card_energy <= curr_energy

# effects when used
func on_use(arena : Node) -> void:
	pass

# effects when usage is done.
#  usually this effect is used to append card at discard pile
func on_use_end(arena : Node) -> void:
	var deck_node := arena.get_node("%Deck") as Node
	deck_node.discard_pile.append(self)

# effects when discarded.
#  card that are used does not fit in this criteria
func on_discard(arena : Node) -> void:
	pass

# effects when drawn
func on_draw(arena : Node) -> void:
	pass

# effects when card is still in hand
func on_turn_end(arena : Node) -> void:
	pass
