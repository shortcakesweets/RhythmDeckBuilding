extends Node

var timer : SceneTreeTimer = null
var unit : float = 0
var tick_count : int = 4

func _ready() -> void:
	set_process(false)

func wait_four_beats() -> void:
	tick_count = 4
	unit = 60.0 / %Rhythm.bpm
	set_process(true)
	timer = get_tree().create_timer(4.0 * unit)
	await timer.timeout
	set_process(false)

func _process(_delta) -> void:
	if %Rhythm.no_beat:
		return
	
	var time : int = round(timer.time_left * 1000.0)
	%BeatBar_GUI.update_visuals(-time)
	
	var time_in_seconds : float = time * 0.001
	if time_in_seconds < unit * float(tick_count):
		_play_beat_tick(true)
		tick_count -= 1

var stream_beat_one := preload("res://assets/sound/sfx_countin_beat1.ogg")
var stream_beat_other := preload("res://assets/sound/sfx_countin_other.ogg")
func _play_beat_tick(beat_one : bool) -> void:
	var sfx : AudioStreamPlayer = %SFX_beat_ticks as AudioStreamPlayer
	if beat_one:
		sfx.stream = stream_beat_one
	else:
		sfx.stream = stream_beat_other
	sfx.play()
