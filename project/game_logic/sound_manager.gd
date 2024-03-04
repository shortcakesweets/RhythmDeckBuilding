extends Node

@onready var SFX = $SFX as Node
@onready var BGM = $BGM as AudioStreamPlayer

var sfx_list := {
	"beat_count" = preload("res://assets/sound/sfx_countin_beat1.ogg"),
	"select" = preload("res://assets/sound/select.ogg"),
	"pause" = preload("res://assets/sound/pause.ogg")
}

var bgm_list := {
	"main_menu" = preload("res://assets/music/loop/main_bgm.ogg"),
	"act_1" = preload("res://assets/music/loop/act1.ogg")
}

func play_sfx(sfx_name : String) -> void:
	var music = sfx_list[sfx_name]
	var sfx := AudioStreamPlayer.new() as AudioStreamPlayer
	SFX.add_child(sfx)
	sfx.stream = music
	sfx.bus = "SFX"
	sfx.play()
	await sfx.finished
	sfx.queue_free()

func play_bgm(bgm_name : String, fade_in_option : bool = false) -> void:
	var music = bgm_list[bgm_name]
	BGM.stop()
	BGM.stream = music
	BGM.play()

func bgm_toggle_pause(toggle : bool) -> void:
	BGM.stream_paused = toggle

func bgm_stop() -> void:
	BGM.stop()
