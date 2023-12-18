extends Node
@onready var audio_stream = $AudioStreamPlayer
@onready var beatbar = $CanvasLayer/Beatbar_UI

enum {LEFT, MID, RIGHT}

@export var offset : float = 0 # ms
@export var bpm : float = 120 # beats per minute
var unit : float = 0.5 # seconds
var gongbad_turn : int = -1

func _ready() -> void:
	set_process(false)
	calculate_unit()
	beatbar.set_idle_speed_by_bpm(bpm * 1.5)
	$"../Character".set_speed_by_bpm(bpm * 2.0)

func calculate_unit() -> void:
	unit = 60.0 / bpm

func get_time() -> float:
	var time = (
		audio_stream.get_playback_position() +
		AudioServer.get_time_since_last_mix() -
		AudioServer.get_output_latency()
	)
	return time

func get_interval(curr_turn : int, position : int = MID) -> float: # by seconds
	if position == LEFT:
		return float(offset) * 0.001 + unit * (float(curr_turn) - 0.5)
	elif position == MID:
		return float(offset) * 0.001 + unit * (float(curr_turn))
	else:
		return float(offset) * 0.001 + unit * (float(curr_turn) + 0.5)

func check_timeout(curr_turn : int) -> bool:
	#return false # delete this later
	var time = get_time()
	if curr_turn == gongbad_turn:
		return get_interval(curr_turn) < time
	else:
		return get_interval(curr_turn, RIGHT) < time

# Returns [valid, precision]
func is_valid_input(curr_turn : int) -> Array:
	#return true # delete this later
	var time : float = get_time()
	var precision : float = time - get_interval(curr_turn)
	var valid : bool = false
	
	if curr_turn != gongbad_turn: # not gongbad
		if time < get_interval(curr_turn, LEFT):
			gongbad_turn = curr_turn
			valid = false
		elif time < get_interval(curr_turn, RIGHT):
			valid = true
			
	return [valid, precision]

var beat_count : int = 0
func _process(_delta) -> void:
	var time = get_time()
	if get_interval(beat_count) < time:
		beatbar.play_idle()
		beat_count += 1
	$"../../Debug System/beatcount".text = str(beat_count)

func _on_music_start_toggled(toggled_on):
	set_process(toggled_on)
	if toggled_on:
		audio_stream.play()
	else:
		audio_stream.stop()
		beat_count = 0
