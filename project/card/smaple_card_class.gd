class_name CardTemplate

enum RARITY {BASE, COMMON, UNCOMMON, RARE, SPECIAL}

@export var card_name : String = ""
@export var card_rarity : RARITY = RARITY.BASE
@export var upgrade : Card = null

@export var is_normal_use : bool = true
@export var is_parry_use : bool = false

@export var card_energy : int = 1
@export var card_illust : CompressedTexture2D = null

@export var use_description := ""
@export var parry_success_description := ""
@export var parry_failed_description := ""
@export var discard_description := ""
@export var holding_description := ""

@export var character_animation := ""
@export var use_sfx : AudioStreamOggVorbis = preload("res://assets/sound/cardPlace2.ogg")

# return card's usability as boolean
func is_available(arena : Node) -> bool:
	if arena.get_node("%Deck").energy < card_energy:
		return false
	
	if arena.get_node("%Turn").parry_mode:
		return is_parry_use
	else:
		return is_normal_use

# card's main ability
func on_use(arena : Node) -> void:
	pass

# card's parry ability
func on_parry(arena : Node) -> void:
	pass

# card's parry success ability
func on_parry_success(arena : Node) -> void:
	pass

# carda's parry fail ability
func on_parry_fail(arena : Node) -> void:
	pass

# card's ability (or behavior) when use end
func on_use_end(arena : Node) -> void:
	var deck_node = arena.get_node("%Deck")
	deck_node.discard_pile.append(self)

# card's ability when discarded
func on_discard(arena : Node) -> void:
	pass

# card's ability when drawed
func on_draw(arena : Node) -> void:
	pass

# card's ability when this card is held on turn end
func on_turn_end(arena : Node) -> void:
	pass
