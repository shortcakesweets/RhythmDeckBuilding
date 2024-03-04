extends Node2D

@onready var Map = $Map
@onready var Room = $Room

const PATH_MAP_DATA = "map_data.tres"

func _ready() -> void:
	GlobalPause.self_detection = true
	#SoundManager.play_bgm()

# to MainMenu. (save N)
func dock_to_main() -> void:
	SceneTransition.scene_transition(SceneTransition.PATH_MAIN_MENU)

func delete_save_file() -> void:
	var dir = DirAccess.open("user://")
	if dir.file_exists(PATH_MAP_DATA):
		dir.remove(PATH_MAP_DATA)

func _room_to_map() -> void:
	await SceneTransition.dissolve(true)
	Room.visible = false
	Map.visible = true
	SoundManager.bgm_toggle_pause(false)
	SceneTransition.dissolve(false)

func _map_to_room() -> void:
	await SceneTransition.dissolve(true)
	Map.visible = false
	Room.visible = true
	SoundManager.bgm_toggle_pause(true)
	SceneTransition.dissolve(false)

# to Room. (save Y, in prev call stack)
func _on_map_start_room(node_data : MapNode):
	await Room.set_room(node_data)
	_map_to_room()

# to Map. (Save Y, in win_update)
func _on_room_back_to_map(win : bool):
	if win:
		Map.win_update()
		_room_to_map()
	else:
		delete_save_file()
		SceneTransition.scene_transition(SceneTransition.PATH_MAIN_MENU)
