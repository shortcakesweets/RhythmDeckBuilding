extends Node

#@export var is_paused : bool = false

var last_paused_time := -1

func _unhandled_input(event) -> void:
	if event.is_echo():
		return
	
	if event.is_action_pressed("default_input"):
		var valid = %Rhythm.is_valid_input(%Turn.curr_turn)
		if valid[0]:
			%Turn.turn()
		# debug
		var debug_label = %Debug.get_node("Label_Precision")
		debug_label.text = str(valid[0]) + "\n" + str(valid[1]) + "ms" + "\n" + "gongbad : " + str(valid[2])

