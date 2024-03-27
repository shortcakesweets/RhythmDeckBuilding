class_name MapNode

enum ROOM_TYPE {MONSTER, EVENT, ELITE, REST, SHOP, TREASURE, BOSS = 100, NONE = -1}

var pixel_position : Vector2 = Vector2(0, 0)
var room_type : ROOM_TYPE = ROOM_TYPE.NONE
var valid : bool = false
var path : Array[bool] = [false, false, false] # left, mid, right
var floor : int = 0
var col : int = 0
var visited : bool = false
var cleared : bool = false
var wave_data : Wave = null
	
func give_random_type(custom_weight : Array) -> ROOM_TYPE:
	room_type = Rng.weighted_rng_array(custom_weight)
	return room_type
