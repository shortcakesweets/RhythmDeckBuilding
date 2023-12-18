extends Node2D

func _ready():
	$Enemy.set_enemy(0)

func _on_button_pressed():
	$Enemy.turn()
