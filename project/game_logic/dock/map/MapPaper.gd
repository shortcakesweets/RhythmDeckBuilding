extends Node2D

const ICON_SIZE := 64 #px
const MARGIN_LEFT := 128
const MARGIN_RIGHT := 128
const MARGIN_BOTTOM := 64
const MAP_TOP_LEFT := Vector2(192, 512)
const MAP_BOTTOM_RIGHT := Vector2(1664, 4160)
const MARGIN_LINE := 10
const MARGIN_RANDOM := 10
const color_normal := Color8(32, 32, 32)
var SLACK_VERTICAL : float = 0
var SLACK_HORIZONTAL : float = 0

@onready var Paper : TileMap = $Paper
@onready var MapNodes : Node2D = $MapNodes
@onready var Map : Node2D = $".."

func _calc_slack(map_data : MapData) -> void:
	var height = map_data.height
	var width = map_data.width
	
	SLACK_HORIZONTAL = ((MAP_BOTTOM_RIGHT.x - MAP_TOP_LEFT.x) - (MARGIN_LEFT + MARGIN_RIGHT)) / (width + 1)
	SLACK_VERTICAL = ((MAP_BOTTOM_RIGHT.y - MAP_TOP_LEFT.y) - MARGIN_BOTTOM) / (height + 1)

func _index_to_pixels(floor : int, col : int) -> Vector2:
	var pixel_position := Vector2.ZERO
	pixel_position.x = MAP_TOP_LEFT.x + MARGIN_LEFT + SLACK_HORIZONTAL * (col + 1)
	pixel_position.y = MAP_BOTTOM_RIGHT.y - MARGIN_BOTTOM - SLACK_VERTICAL * (floor + 1)
	return pixel_position

var map_icon := preload("res://game_logic/dock/map/map_icon.tscn")
func show_map(map_data : MapData) -> void:
	for child in MapNodes.get_children():
		child.queue_free()
	
	for floor in range(map_data.height):
		for col in range(map_data.width):
			var map_node = map_data.map_grid[floor][col] as MapNode
			if not map_node.valid:
				continue
			_add_map_node(map_data, floor, col)
	_add_map_node(map_data, map_data.height, 0) # add boss room
	
	# show path
	for floor in range(map_data.height - 1):
		for col in range(map_data.width):
			var map_node = map_data.map_grid[floor][col] as MapNode
			if not map_node.valid:
				continue
			
			var point_from : Vector2 = map_node.pixel_position - Vector2(0, ICON_SIZE / 2 + MARGIN_LINE)
			for path_dir in [-1, 0, 1]:
				if not map_node.path[path_dir + 1]:
					continue
				
				var map_node_to = map_data.map_grid[floor + 1][col + path_dir] as MapNode
				var point_to : Vector2 = map_node_to.pixel_position + Vector2(0, ICON_SIZE / 2 + MARGIN_LINE)
				_add_path_node(point_from, point_to)
	# add boss path
	for col in range(map_data.width):
		var map_node = map_data.map_grid[map_data.height - 1][col] as MapNode
		var point_to : Vector2 = map_data.map_grid[map_data.height][0].pixel_position + Vector2(0, 256)
		if not map_node.valid:
			continue
		
		var point_from : Vector2 = map_node.pixel_position - Vector2(0, ICON_SIZE)
		_add_path_node(point_from, point_to)

# helper function of show_map()
func _add_map_node(map_data : MapData, floor : int, col : int) -> void:
	var map_node = map_data.map_grid[floor][col] as MapNode
	var new_map_node = map_icon.instantiate()
	MapNodes.add_child(new_map_node)
	new_map_node.position = map_node.pixel_position
	if Vector2(floor, col) in map_data.available_list:
		new_map_node.clickable = true
	new_map_node.set_node_data(map_node)
	new_map_node.mouse_left_click.connect(Map._on_icon_click)

# helper function of show_map(). unit : px
func _add_path_node(point_from : Vector2, point_to : Vector2) -> void:
	var new_path := Line2D.new()
	MapNodes.add_child(new_path)
	new_path.default_color = color_normal
	new_path.add_point(point_from)
	new_path.add_point(point_to)
	new_path.width = 5
	new_path.begin_cap_mode = Line2D.LINE_CAP_ROUND
	new_path.end_cap_mode = Line2D.LINE_CAP_ROUND

func set_map_node_position(map_data : MapData) -> void:
	_calc_slack(map_data)
	
	for floor in range(map_data.height):
		for col in range(map_data.width):
			if not map_data.map_grid[floor][col].valid:
				continue
			var random_vector : Vector2 = Vector2.UP.rotated(Rng.rng.randf_range(0,2*PI)) * MARGIN_RANDOM
			map_data.map_grid[floor][col].pixel_position = _index_to_pixels(floor, col) + random_vector
	map_data.map_grid[map_data.height][0].pixel_position = Vector2(960, 256)
