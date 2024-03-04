extends CanvasLayer

@onready var color_rect := $ColorRect
@onready var anim_player := $AnimationPlayer

const PATH_MAIN_MENU := "res://game_logic/main_menu/main_menu.tscn"
const PATH_DOCK := "res://game_logic/dock/dock.tscn"

func _ready() -> void:
	pass

func dissolve(run_backwards : bool) -> void:
	if run_backwards:
		anim_player.play("dissolve")
	else:
		anim_player.play_backwards("dissolve")
	await anim_player.animation_finished

func scene_transition(path : String) -> void:
	await dissolve(true)
	get_tree().change_scene_to_file(path)
	dissolve(false)
