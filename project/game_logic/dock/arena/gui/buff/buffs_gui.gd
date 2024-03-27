extends Node2D

@onready var buff_gui = preload("res://game_logic/dock/arena/gui/buff/buff_gui.tscn")

func update_visuals(buff_list : Array[Buff]) -> void:
	for child in self.get_children():
		child.queue_free()
	
	for idx in range(buff_list.size()):
		var buff = buff_list[idx]
		if buff != null:
			var new_buff_gui = buff_gui.instantiate()
			add_child(new_buff_gui)
			new_buff_gui.position = Vector2(idx * (64+20), 0)
			new_buff_gui.update_visuals(buff)

func _ready() -> void:
	pass

func _debug_test() -> void:
	var buff_list : Array[Buff] = []
	
	var buff : Buff = load("res://buff/sample_buff.tres") as Buff
	buff.buff_count = 4
	buff_list.append(buff)
	
	update_visuals(buff_list)
