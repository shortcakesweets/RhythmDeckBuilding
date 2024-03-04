extends Resource
class_name MapData

const PATH : String = "user://map_data.tres"

enum ROOM_TYPE {MONSTER, EVENT, ELITE, REST, SHOP, TREASURE, BOSS, NONE = -1}
enum {LEFT = -1, MID = 0, RIGHT = 1, INVALID = -2}
const TYPE_WEIGHT := [45, 22, 16, 12, 5, 0]
const height := 15
const width := 7
const path_density := 6

@export var valid : bool = false
@export var act : int = 1
@export var map_grid : Array = []
@export var last_visited : Vector2 = Vector2(-1, -1)
@export var cleared_list : Array[Vector2] = []
@export var available_list : Array[Vector2] = [Vector2(0,0), Vector2(0,1), Vector2(0,2), Vector2(0,3), Vector2(0,4), Vector2(0,5), Vector2(0,6)]

func make_map() -> void:
	# make empty map_grid
	map_grid.clear()
	for floor in range(height):
		var floor_array : Array[MapNode] = []
		for col in range(width):
			var room := MapNode.new()
			room.floor = floor
			room.col = col
			floor_array.append(room)
		map_grid.append(floor_array)
	map_grid.append([MapNode.new()]) # append bossroom
	
	# make paths
	var prev_choice := -1
	for i in range(path_density):
		var choice = prev_choice
		while choice == prev_choice:
			choice = Rng.rng.randi_range(0, width - 1)
		prev_choice = choice
		
		# traverse floor 0~height
		for floor in range(height - 1):
			map_grid[floor][choice].valid = true
			var path_dir := INVALID
			while path_dir == INVALID:
				path_dir = Rng.rng.randi_range(LEFT, RIGHT)
				# OOB invalidation
				if choice + path_dir < 0 or choice + path_dir >= width:
					path_dir = INVALID
					continue
				
				# cross path invalidation
				if path_dir == LEFT and map_grid[floor][choice-1].path[2]:
					path_dir = INVALID
				elif path_dir == RIGHT and map_grid[floor][choice+1].path[0]:
					path_dir = INVALID
				
			map_grid[floor][choice].path[path_dir + 1] = true
			choice += path_dir
		map_grid[height-1][choice].valid = true
		# add 15th <-> boss path
		for col in range(width):
			map_grid[height-1][col].path[MID] = true
		map_grid[height][0].valid = true
	
	_assign_types()

# make_map()'s helper function
func _assign_types() -> void:
	# assign random types for all floor/cols
	for floor in range(height):
		for col in range(width):
			if map_grid[floor][col].valid:
				map_grid[floor][col].give_random_type(TYPE_WEIGHT)
	map_grid[height][0].room_type = ROOM_TYPE.BOSS
	
	# reassign constant floors
	# 1. first floor is always monster
	# 2. 9th floor is always treasure
	# 3. 15th floor is always rest-site
	for col in range(width):
		if map_grid[0][col].valid:
			map_grid[0][col].room_type = ROOM_TYPE.MONSTER
		if map_grid[8][col].valid:
			map_grid[8][col].room_type = ROOM_TYPE.TREASURE
		if map_grid[height - 1][col].valid:
			map_grid[height - 1][col].room_type = ROOM_TYPE.REST
	
	# fix wrong assignments
	# 1. Elite and Rest sites cannot be assigned below 6th floor
	# 2. Elite, Rest, Shop sites cannot be consecutive
	#  - check previous site
	# 3. All paths should be unique
	#  - check previous, and ban same types
	# 4. Rest cannot be at 14th floor (height-1)
	for floor in range(height - 2, -1, -1):
		for col in range(width):
			if not map_grid[floor][col].valid:
				continue
			
			var filter := [true, true, true, true, true, true]
			# 1
			if floor < 5:
				filter[ROOM_TYPE.ELITE] = false
				filter[ROOM_TYPE.REST] = false
			
			# 2
			for path_dir in [-1, 0, 1]:
				if map_grid[floor][col].path[path_dir + 1]:
					if map_grid[floor + 1][col + path_dir].room_type == ROOM_TYPE.ELITE:
						filter[ROOM_TYPE.ELITE] = false
					elif map_grid[floor + 1][col + path_dir].room_type == ROOM_TYPE.REST:
						filter[ROOM_TYPE.REST] = false
					elif map_grid[floor + 1][col + path_dir].room_type == ROOM_TYPE.SHOP:
						filter[ROOM_TYPE.SHOP] = false
			
			# 3
			# ignored
			
			# 4
			if floor == height - 2:
				filter[ROOM_TYPE.REST] = false
			
			if filter[map_grid[floor][col].room_type] == false:
				var modified_weight_array = TYPE_WEIGHT.duplicate(true)
				for i in range(modified_weight_array.size()):
					if filter[i] == false:
						modified_weight_array[i] = 0
				map_grid[floor][col].give_random_type(modified_weight_array)

func append_clear_at(index : Vector2 = last_visited) -> void:
	cleared_list.append(index)
	last_visited = index
	var map_node : MapNode = map_grid[index.x][index.y]
	map_node.visited = true
	map_node.cleared = true
	available_list.clear()
	if index.x + 1 == height:
		available_list.append(Vector2(height, 0))
	else:
		for path_dir in [-1, 0, 1]:
			if map_node.path[path_dir + 1]:
				available_list.append(Vector2(index.x + 1, index.y + path_dir))
	save()

func visit_at(index : Vector2) -> void:
	last_visited = index
	map_grid[index.x][index.y].visited = true
	available_list.clear()
	available_list.append(index)
	save()

func save() -> void:
	ResourceSaver.save(self, PATH)

func load() -> Resource:
	if not ResourceLoader.exists(PATH):
		save()
	return load(PATH)
