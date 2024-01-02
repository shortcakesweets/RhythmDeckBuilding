extends Node2D
@export var card_resource_raw : Card = null

@onready var pair_box = [$EffectIcon/Control/VBoxContainer/Pair1, $EffectIcon/Control/VBoxContainer/Pair2, $EffectIcon/Control/VBoxContainer/Pair3, $EffectIcon/Control/VBoxContainer/Pair4]
@onready var texture_icon := {
	"Attack" : preload("res://assets/vector icon/Attack.png"),
	"Defend" : preload("res://assets/vector icon/Defend.png"),
	"Knockback" : preload("res://assets/vector icon/Knockback.png"),
	"Parry" : preload("res://assets/vector icon/Parry.png")
}

func _ready():
	draw_icon()

func draw_icon() -> void:
	$Common_Sprite.visible = false
	$Uncommon_Sprite.visible = false
	$Rare_Sprite.visible = false
	for pair_id in range(4):
		pair_box[pair_id].visible = false
	if card_resource_raw == null:
		return
	
	# Sprites by Rarity
	$Common_Sprite.visible = (card_resource_raw.card_rarity == Card.RARITY.COMMON)
	$Uncommon_Sprite.visible = (card_resource_raw.card_rarity == Card.RARITY.UNCOMMON)
	$Rare_Sprite.visible = (card_resource_raw.card_rarity == Card.RARITY.RARE)
	
	var effect : Dictionary
	if card_resource_raw.is_upgraded:
		effect = card_resource_raw.upgraded_effect
	else:
		effect = card_resource_raw.effect
	
	var pair_id := 0
	for key in effect.keys():
		pair_box[pair_id].visible = true
		if effect[key] != 0:
			set_pair(pair_id, key, effect[key])
			pair_id += 1
	
	while pair_id < 4:
		pair_box[pair_id].visible = false
		pair_id += 1

func set_pair(pair_id : int, key : String, value) -> void:
	pair_box[pair_id].get_node("key").texture = texture_icon[key]
	pair_box[pair_id].get_node("value").text = str(value)

func animate_and_draw_card(new_card_resource : Card = null) -> void:
	card_resource_raw = new_card_resource
	draw_icon()
