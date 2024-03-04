extends Control

const scroll_speed : int = 128 #px
const scroll_min : int = -3328 # -26 (scroll unit)
const scroll_max : int = 256 # 2 (scroll unit)
@onready var MapPaper = $"../MapPaper"

func _ready() -> void:
	MapPaper.position.y = scroll_max

func _unhandled_input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			MapPaper.position.y = clamp(MapPaper.position.y + scroll_speed, scroll_min, scroll_max)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			MapPaper.position.y = clamp(MapPaper.position.y - scroll_speed, scroll_min, scroll_max)
	elif event.is_action_pressed("ui_cancel") and not event.is_echo():
		# Implement Pause
		pass

func scroll_top_to_floor(floor : int) -> void:
	floor = clamp(floor, 1, 15)
	var height = clamp((15 - floor) * -2 * scroll_speed, scroll_min, scroll_max)
	var tween = get_tree().create_tween()
	tween.tween_property(MapPaper, "position:y", height, 3.0).set_trans(Tween.TRANS_QUART)

