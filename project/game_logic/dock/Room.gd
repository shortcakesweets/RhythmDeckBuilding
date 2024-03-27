extends Node2D

enum ROOM_TYPE {MONSTER, EVENT, ELITE, REST, SHOP, TREASURE, BOSS, NONE = -1}

var Arena := preload("res://game_logic/dock/arena/Arena.tscn")

signal back_to_map(win : bool)
signal back_to_main

func set_room(node_data : MapNode) -> void:
	match node_data.room_type:
		ROOM_TYPE.MONSTER, ROOM_TYPE.ELITE:
			_make_arena(node_data)
		ROOM_TYPE.REST:
			_make_arena(node_data)
		ROOM_TYPE.SHOP:
			_make_arena(node_data)
		ROOM_TYPE.TREASURE:
			_make_arena(node_data)
		ROOM_TYPE.EVENT:
			# reroll between [MONSTER, SHOP, TREASURE, EVENT]
			_make_arena(node_data)
		ROOM_TYPE.BOSS:
			_make_arena(node_data)
		_:
			_make_arena(node_data)

func _make_arena(node_data : MapNode) -> void:
	for child in get_children():
		child.queue_free()
	var new_arena = Arena.instantiate()
	add_child(new_arena)
	new_arena.set_arena(node_data)
	new_arena.connect("back_to_map", _on_back_to_map)
	new_arena.connect("back_to_main", _on_back_to_main)

func _on_back_to_map(win : bool) -> void:
	for child in get_children():
		child.queue_free()
	emit_signal("back_to_map", win)

func _on_back_to_main() -> void:
	emit_signal("back_to_main")


