extends Resource
class_name Card

enum RARITY {BASE, COMMON, UNCOMMON, RARE, SPECIAL}

@export var card_name : String = ""
@export var card_rarity : RARITY = RARITY.BASE
@export var upgrade : Card = null

@export var is_normal_use : bool = true
@export var is_parry_use : bool = false
@export var card_functions : Script = null

@export var card_energy : int = 1
@export var card_illust : CompressedTexture2D = null

@export var use_description := ""
@export var parry_success_description := ""
@export var parry_failed_description := ""
@export var discard_description := ""
@export var holding_description := ""

@export var character_animation := ""
@export var use_sfx : AudioStreamOggVorbis = preload("res://assets/sound/cardPlace2.ogg")

# check if card is usable
func is_available(arena : Node) -> bool:
	if card_functions != null and card_functions.has_method("is_available"):
		return card_functions.is_available(arena, self)
	
	var parry_mode : bool = arena.get_node("%Turn").parry_mode
	var curr_energy : int = arena.get_node("%Deck").energy
	return ((is_normal_use and !parry_mode) or (is_parry_use and parry_mode)) and (card_energy <= curr_energy)

# card functions
func on_use(arena : Node) -> void:
	if card_functions != null and card_functions.has_method("on_use"):
		card_functions.on_use(arena)

func on_parry(arena : Node) -> void:
	if card_functions != null and card_functions.has_method("on_parry"):
		card_functions.on_parry(arena)

func on_parry_success(arena : Node) -> void:
	if card_functions != null and card_functions.has_method("on_parry_success"):
		card_functions.on_parry_success(arena)

func on_parry_fail(arena : Node) -> void:
	if card_functions != null and card_functions.has_method("on_parry_fail"):
		card_functions.on_parry_fail(arena)

func on_use_end(arena : Node) -> void:
	if card_functions != null and card_functions.has_method("on_use_end"):
		card_functions.on_use_end(arena)
	else:
		var deck_node = arena.get_node("%Deck")
		deck_node.discard_pile.append(self)

func on_discard(arena : Node) -> void:
	if card_functions != null and card_functions.has_method("on_discard"):
		card_functions.on_discard(arena)

func on_draw(arena : Node) -> void:
	if card_functions != null and card_functions.has_method("on_draw"):
		card_functions.on_draw(arena)

func on_turn_end(arena : Node) -> void:
	if card_functions != null and card_functions.has_method("on_turn_end"):
		card_functions.on_turn_end(arena)
