extends Node2D

@onready var enemy_list = [
	$Enemy_list/Enemy_GUI0,
	$Enemy_list/Enemy_GUI1,
	$Enemy_list/Enemy_GUI2]

func _ready() -> void:
	pass

func update_visuals() -> void:
	var enemy_data_list : Array[Enemy] = %Enemies.enemy_list
	for i in range(3):
		var enemy_data : Enemy = null
		if i < enemy_data_list.size():
			enemy_data = enemy_data_list[i]
		enemy_list[i].update_visuals(enemy_data)
