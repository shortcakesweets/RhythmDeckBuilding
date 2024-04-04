extends Node

#@export var is_paused : bool = false

var last_paused_time := -1
enum KEY_CODE {NO_INPUT = -2, DEFAULT = -1, RELOAD = 10, PARRY = 100}

func _unhandled_input(event) -> void:
	if event.is_echo():
		return
	
	for i in range(6):
		if event.is_action_pressed("card_" + str(i)):
			# No rhythm handling
			%Turn.turn(i)
	
	if event.is_action_pressed("default_input"):
		%Turn.turn(-1)
	
	if event.is_action_pressed("reload"):
		%Turn.turn(10)
