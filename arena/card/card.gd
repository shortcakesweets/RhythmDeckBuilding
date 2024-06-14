extends Resource
class_name Card

enum RARITY{
	BASE, COMMON, UNCOMMON, RARE, SPECIAL
}

@export var card_name : String = ""
@export var card_rarity : RARITY = RARITY.BASE
@export var upgrade : Card = null

# IF card energy X is true, the card will be available at card_energy,
#  but it will use all energy when used
#  that energy is stored in used_energy
@export var card_energy : int = 1
@export var card_energy_X : bool = false
var used_energy : int = 0
@export var card_energy_refill : int = 0
@export var card_illust : CompressedTexture2D = null

@export var description := ""

@export var character_animation := "Sword_Idle"
@export var use_sfx : AudioStreamOggVorbis = null

# if exhaust, card vanishes after use
# if etherial, card vanishes if not used
@export var exhaust : bool = false
@export var etherial : bool = false
@export var etherial_max_count : int = 1
var etherial_count : int = etherial_max_count

# check if card is usable
func is_available(arena : Node) -> bool:
	var character_data : CharacterData = arena.get_node("%Character").character_data
	return card_energy <= character_data.energy

# apply card's effect, and animate character
func on_use(arena : Node) -> void:
	var character_data : CharacterData = arena.get_node("%Character").character_data
	if not card_energy_X:
		character_data.apply_energy(-card_energy)
	else:
		used_energy = character_data.energy
		character_data.apply_energy(-character_data.energy)
	character_data.apply_energy(card_energy_refill)
	
	# animation update
	character_data.current_animation = character_animation
	
	_on_use_end(arena)

# effects when usage is done.
#  usually this effect is used to append card at discard pile
func _on_use_end(arena : Node) -> void:
	var deck_node := arena.get_node("%Deck") as Node
	var card_idx : int = deck_node._get_card_idx(self)
	if exhaust:
		deck_node._exhaust(card_idx)
	else:
		deck_node.hand_pile[card_idx] = null
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
	if etherial:
		if etherial_count == 0:
			var deck_node := arena.get_node("%Deck") as Node
			deck_node._exhaust(deck_node._get_card_idx(self))
			etherial_count = etherial_max_count
		else:
			etherial_count -= 1

# effects when card is exhausted
func on_exhaust(arena : Node) -> void:
	var character_data : CharacterData = arena.get_node("%Character").character_data
	var buff_value := character_data.get_buff_count("mist")
	if buff_value != 0:
		character_data.apply_defense(buff_value)
