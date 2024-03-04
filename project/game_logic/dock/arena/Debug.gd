extends Control

@onready var Arena = $".."

func _on_win_pressed():
	Arena.emit_signal("back_to_map", true)

func _on_lose_pressed():
	Arena.emit_signal("back_to_map", false)

func _on_return_to_main_pressed():
	Arena.emit_signal("back_to_main")

func _process(_delta) -> void:
	# debug
	var debug_text := ""
	debug_text += "curr_turn : " + str(%Turn.curr_turn) + "\n"
	debug_text += "curr_beat : " + str(%Rhythm.beat_count) + "\n"
	#debug_text += "interval : " + str(%Rhythm._get_interval(%Turn.curr_turn)) + "\n"
	$Label_Turn.text = debug_text
