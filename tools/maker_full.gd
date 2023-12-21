extends Node2D

func _ready():
	$"FSM maker".visible = false
	$"Mob Maker".visible = true

func _on_button_pressed():
	$"FSM maker".visible = not $"FSM maker".visible
	$"Mob Maker".visible = not $"Mob Maker".visible

func _on_file_check_pressed():
	# WIP
	pass # Replace with function body.
