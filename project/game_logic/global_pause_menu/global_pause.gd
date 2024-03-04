extends CanvasLayer

signal paused
signal unpaused

# only checks for pause-in, not pause-out.
@export var self_detection : bool = true
var prev_pause_time : int = 0

# handle unpause, option when esc pressed
func _unhandled_input(event) -> void:
	if event.is_action("pause") and Time.get_ticks_msec() > prev_pause_time + 300:
		_stamp_time()
		if %Options.visible:
			%Options._change_option_visibility(false)
			%Options._on_any_button_pressed()
		else:
			toggle_pause()

func _stamp_time() -> void:
	prev_pause_time = Time.get_ticks_msec()

func toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	self.visible = get_tree().paused

func back_to_main() -> void:
	pass
