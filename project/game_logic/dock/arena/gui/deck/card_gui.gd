extends Node2D

const COLOR_AVAILABLE := Color.CYAN
const COLOR_PARRYABLE := Color.GREEN_YELLOW

var offset : int = 0

func _ready() -> void:
	update_card_info(null)
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
	var desc_text = ""
	desc_text += card_data.use_description
	if card_data.parry_success_description != "":
		desc_text += "\n"
		desc_text += card_data.parry_success_description
	if card_data.parry_failed_description != "":
		desc_text += "\n"
		desc_text += card_data.parry_failed_description
	$Control/description.text = _capsulate_center(desc_text)

# Only card animations, glowlines
func update_card_animation(card_data : Card, current_energy : int, is_parrying : bool) -> void:
	if card_data == null:
		_animate_card_height(false)
		$Control/glow_line.visible = false
		return
	
	var is_available : bool = true
	$Control/glow_line.visible = false
	if current_energy >= card_data.card_energy:
		if is_parrying and card_data.is_parry_use:
			$Control/glow_line.visible = true
			$Control/glow_line.default_color = COLOR_PARRYABLE
		elif not is_parrying and card_data.is_normal_use:
			$Control/glow_line.visible = true
			$Control/glow_line.default_color = COLOR_AVAILABLE
		else:
			is_available = false
	else:
		is_available = false
	_animate_card_height(is_available)

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
