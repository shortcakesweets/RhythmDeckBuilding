extends Node2D

const COLOR_AVAILABLE := Color.CYAN
const COLOR_PARRYABLE := Color.GREEN_YELLOW

@export var display_card_info : Card = null

var offset : int = 0

func _ready() -> void:
	update_card_info(display_card_info)
	offset = self.position.y
	_animate_card_height(false)

# Only card info
func update_card_info(card_data : Card) -> void:
	if card_data == null:
		_set_empty_visual()
		return
	
	# update bg - wip
	
	# write card name, illust, description
	$Control/card_name.text = _capsulate_center(card_data.card_name)
	$Control/illust.texture = card_data.card_illust
	$Control/description.text = _capsulate_center(card_data.description)

# Only card animations, glowlines
func update_card_animation(arena, card : Card) -> void:
	if card == null:
		_animate_card_height(false)
		$Control/glow_line.visible = false
		return
	
	var is_available := card.is_available(arena)
	$Control/glow_line.visible = is_available
	$Control/glow_line.default_color = COLOR_AVAILABLE
	_animate_card_height(is_available)

#region private
func _animate_card_height(is_available : bool) -> void:
	var tween = get_tree().create_tween()
	var final_value : int = offset
	if is_available:
		final_value = offset - 64
	tween.tween_property(self, "position:y", final_value, 0.2).set_trans(Tween.TRANS_EXPO)

func _set_empty_visual() -> void:
	$Control/card_name.text = ""
	$Control/illust.texture = null
	$Control/description.text = ""
	$Control/glow_line.visible = false

func _capsulate_center(text : String) -> String:
	return "[center]" + text + "[/center]"
#endregion
