extends Node

@onready var pause_menu = $".."
func _unhandled_input(event) -> void:
	if not pause_menu.self_detection:
		return
	
	if event.is_action("pause") and Time.get_ticks_msec() > pause_menu.prev_pause_time + 300:
		pause_menu._stamp_time()
		pause_menu.toggle_pause()
		SoundManager.play_sfx("pause")
