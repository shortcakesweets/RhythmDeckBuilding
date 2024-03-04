extends Node2D

signal start_room(node_data : MapNode)

var map_data : MapData = MapData.new()
@onready var MapPaper := $MapPaper
@onready var Scroller := $MouseDetect
@onready var RoomViewer := $RoomViewer

func _ready() -> void:
	SoundManager.play_bgm("act_1")
	
	map_data = map_data.load()
	if not map_data.valid:
		map_data.make_map()
		MapPaper.set_map_node_position(map_data)
		map_data.valid = true
		map_data.save()
	MapPaper.show_map(map_data)
	Scroller.scroll_top_to_floor(map_data.last_visited.x)

func _on_icon_click(node_data : MapNode) -> void:
	print(node_data.floor, ' ', node_data.col)
	
	RoomViewer.set_room_data(node_data)
	RoomViewer.visible = true

func win_update() -> void:
	map_data.append_clear_at()
	MapPaper.show_map(map_data)
	RoomViewer.visible = false

