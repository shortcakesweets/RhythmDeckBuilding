extends Control

@onready var buff_icon := preload("res://arena/components/buffs_gui/buff_gui.tscn")

func update_visuals(buff_list : Array[Buff]) -> void:
	for child in %BuffList.get_children():
		child.queue_free()
	
	for buff in buff_list:
		var new_icon := buff_icon.instantiate()
		%BuffList.add_child(new_icon)
		new_icon.update_visuals(buff)
