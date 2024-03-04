extends Node

var curr_turn : int = 0

# Turn logic
func turn(card : Card = null) -> void:
	
	%Character.play_animation_once("Sword_Idle")
	
	# last : increment turn count
	curr_turn += 1

func turn_value(card : Card = null) -> void:
	pass

func turn_animation(card : Card = null) -> void:
	pass
