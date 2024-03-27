extends Node

#@export var is_paused : bool = false

var last_paused_time := -1
enum KEY_CODE {NO_INPUT = -2, DEFAULT = -1, RELOAD = 10, PARRY = 100}

func _unhandled_input(event) -> void:
	if event.is_echo():
		return
	
	# rhythm debugging key
	if event.is_action_pressed("default_input"):
		var valid = %Rhythm.is_valid_input(%Turn.curr_turn)
		if valid[0]:
			%Turn.turn()
		# debug
		_set_debug_label(valid)
		return
	
	var key_code := KEY_CODE.NO_INPUT
	if event.is_action_pressed("default_input"):
		key_code = KEY_CODE.DEFAULT
	for i in range(6):
		if event.is_action_pressed("card_" + str(i)):
			key_code = i
	if event.is_action_pressed("reload"):
		key_code = KEY_CODE.RELOAD
	if event.is_action_pressed("parry"):
		key_code = KEY_CODE.PARRY
	
	if key_code != KEY_CODE.NO_INPUT:
		#print(key_code)
		var valid = %Rhythm.is_valid_input(%Turn.curr_turn)
		if valid[0]:
			%Turn.turn(key_code)
			_set_debug_label(valid)

func _set_debug_label(valid : Array) -> void:
	var debug_label = %Debug.get_node("Label_Precision")
	debug_label.text = str(valid[0]) + "\n" + str(valid[1]) + "ms" + "\n" + "gongbad : " + str(valid[2])
