extends Node2D

@onready var start_button_text : Label = $Main/Start/Label
const PATH_MAP_DATA := "map_data.tres"

func _ready() -> void:
	GlobalPause.self_detection = false
	if detect_savefile():
		start_button_text.text = "CONTINUE"
	else:
		start_button_text.text = "START"
	SoundManager.play_bgm("main_menu")

func detect_savefile() -> bool:
	var dir = DirAccess.open("user://")
	return dir.file_exists(PATH_MAP_DATA)

func _on_quit_game_pressed():
	get_tree().quit()

func _on_start_pressed():
	SceneTransition.scene_transition(SceneTransition.PATH_DOCK)
