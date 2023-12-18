extends Node

enum MAP_TYPE {MONSTER, EVENT, ELITE, REST, SHOP, TREASURE, BOSS, NONE = -1}
const TYPE_WEIGHT := [45, 22, 16, 12, 5, 0]

@onready var visual = $Map/Visual

func _ready() -> void:
	make_map()
	show_map()
	set_node_metadata()

# Uses STS map genration logic
var map := []
const width := 7
const height := 15
const path_density := 6
class map_node:
	var type := MAP_TYPE.NONE
	var left := false
	var up := false
	var right := false
	var pos := Vector2.ZERO
	var floor := 0
	var index := 0
	var prev_room := []
	var node_metadata : Dictionary = {}
	
	func _init(floor_ : int = 0, index_ : int = 0):
		floor = floor_
		index = index_
	
	func is_valid_node() -> bool:
		return left or up or right
	
	func give_random_type(custom_weight : Array = TYPE_WEIGHT) -> MAP_TYPE:
		type = Rng.weighted_rng(custom_weight)
		return type

func make_map() -> void:
	map.clear()
	# Make H * W grid with nodes
	for floor in range(height):
		var floor_array : Array[map_node] = []
		for i in range(width):
			var room := map_node.new(floor, i)
			floor_array.append(room)
		map.append(floor_array)
	
	# Make paths
	var prev_choice : int = -1
	for i in range(path_density):
		# Set starting point
		var choice = prev_choice
		while choice == prev_choice:
			choice = Rng.rng.randi_range(0,width-1)
		prev_choice = choice
		
		# Traverse path
		var prev_type := MAP_TYPE.NONE
		for floor in range(height-1):
			var valid := false
			var branch := -1
			var prev_index = choice
			while not valid:
				branch = Rng.rng.randi_range(0,2)
				# Validity check
				if branch == 0 and choice != 0: # Left
					valid = not map[floor][choice-1].right
				elif branch == 2 and choice != width - 1: # Right
					valid = not map[floor][choice+1].left
				elif branch == 1:
					valid = true
			if branch == 0:
				map[floor][choice].left = true
				choice -= 1
			elif branch == 1:
				map[floor][choice].up = true
			else:
				map[floor][choice].right = true
				choice += 1
			map[floor+1][choice].prev_room.append([floor,prev_index])
		map[height-1][choice].up = true
	
	# Assign Types
	for floor in range(height):
		for i in range(width):
			if map[floor][i].is_valid_node():
				if floor==0:
					map[floor][i].type = MAP_TYPE.MONSTER
				elif floor==8:
					map[floor][i].type = MAP_TYPE.TREASURE
				elif floor==height-1: #14
					map[floor][i].type = MAP_TYPE.REST
				else:
					map[floor][i].give_random_type()
	
	# Reassign wrong rooms
	reassign_rooms()

func reassign_rooms() -> void:
	# 1. Elite and Rest sites cannot be assigned below 6th floor
	# 2. Elite, Rest, Shop sites cannot be consecutive
	#  - check previous site
	# 3. All paths should be unique
	#  - check previous, and ban same types
	# 4. Rest cannot be at 14th floor (height-1)
	for floor in range(1,height):
		for i in range(width):
			var filter = [true, true, true, true, true, true]
			# 1.
			if floor < 5:
				filter[MAP_TYPE.ELITE] = false
				filter[MAP_TYPE.REST] = false
			# 2.
			for prev_room in map[floor][i].prev_room:
				if map[prev_room[0]][prev_room[1]].type == MAP_TYPE.ELITE:
					filter[MAP_TYPE.ELITE] = false
				elif map[prev_room[0]][prev_room[1]].type == MAP_TYPE.REST:
					filter[MAP_TYPE.REST] = false
				elif map[prev_room[0]][prev_room[1]].type == MAP_TYPE.SHOP:
					filter[MAP_TYPE.SHOP] = false
			# 3.
			if not (floor == height-1 or floor == 8):
				for prev_room in map[floor][i].prev_room:
					if map[prev_room[0]][prev_room[1]].left and not i == prev_room[1]-1:
						filter[map[floor][prev_room[1]-1].type] = false
					elif map[prev_room[0]][prev_room[1]].up and not i == prev_room[1]:
						filter[map[floor][prev_room[1]].type] = false
					elif map[prev_room[0]][prev_room[1]].right and not i == prev_room[1]+1:
						filter[map[floor][prev_room[1]+1].type] = false
			# 4.
			if floor == height-2: # floor == 13:
				filter[MAP_TYPE.REST] = false
			
			if filter[map[floor][i].type] == false:
				# make new weight array
				var modified_weight_array = TYPE_WEIGHT.duplicate(true)
				for filter_i in range(6):
					if not filter[filter_i]:
						modified_weight_array[filter_i] = 0
				map[floor][i].give_random_type(modified_weight_array)

const left_margin := 0.2
const right_margin := 0.8
const level_seperation := 250 # pixels
const line_margin := 64 # pixels
const rand_pos_radius := 16 # pixels
var icon = preload("res://gamelogic/RoomSelector/room_Icon.tscn")
func show_map() -> void:
	# set each node pos
	for floor in range(height):
		var margin_randomizer := Rng.rng.randf_range(0, 0.1)
		var x_start := (left_margin + margin_randomizer) * 1920 #pixels
		var x_end := (right_margin - margin_randomizer) * 1920  #pixels
		var y := -(floor-1) * level_seperation
		for i in range(width):
			var x := ((width-1-i) * x_start + i * x_end) / (width-1)
			var random_vector = Vector2.UP.rotated(Rng.rng.randf_range(0,2*PI)) * rand_pos_radius
			map[floor][i].pos = Vector2(x,y) + random_vector
	
	# put sprite and connect signal
	for floor in range(height):
		for index in range(width):
			if map[floor][index].is_valid_node():
				var icon_instance = icon.instantiate()
				visual.add_child(icon_instance)
				icon_instance.position = map[floor][index].pos
				icon_instance.floor = floor
				icon_instance.index = index
				icon_instance.draw_type(map[floor][index].type)
				icon_instance.interact.connect(_on_visual_icon_clicked)
	
	for floor in range(1,height):
		for index in range(width):
			if map[floor][index].is_valid_node():
				for prev_room in map[floor][index].prev_room:
					var line = Line2D.new()
					visual.add_child(line)
					line.add_point(map[floor][index].pos + Vector2(0,line_margin))
					line.add_point(map[prev_room[0]][prev_room[1]].pos - Vector2(0,line_margin))
					line.width = 5
					line.begin_cap_mode = Line2D.LINE_CAP_ROUND
					line.end_cap_mode = Line2D.LINE_CAP_ROUND

func set_node_metadata() -> void:
	pass

const scroll_speed := 100
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			visual.position.y += scroll_speed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			visual.position.y -= scroll_speed

############################################################

@onready var RoomInfo_UI = $RoomInfo/Combat_Info
var curr_floor := 0
var curr_index := 0
func _on_visual_icon_clicked(floor : int, index : int):
	#print(floor, index)
	var valid_interaction : bool = false
	if floor == curr_floor:
		if curr_floor == 0:
			valid_interaction = true
		else:
			for prev_room in map[floor][index]:
				if curr_floor == prev_room[0] and curr_index == prev_room[1]:
					valid_interaction = true
	if not valid_interaction:
		return
	
	RoomInfo_UI.visible = true
	RoomInfo_UI.set_metadata(map[floor][index].node_metadata)
