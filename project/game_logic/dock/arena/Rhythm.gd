extends Node
@onready var character = $"../../GUI/Character"
enum {LEFT, MID, RIGHT}
const DEFAULT_UNIT : int = 500 #ms

# Debugging, Balancing purpose
@export var no_beat : bool = false
@export var bpm : float = 120 # beats per minute

var time_array : Array[int] = []
var gongbad_turn : int = -1
var beat_count : int = 0

func _ready() -> void:
	set_process(false)
	time_array = get_time_array_data("res://assets/music/sample_music.txt")
	%BeatBar_GUI.set_bars(time_array)

func _get_time_ms() -> int:
	if not %BGM.playing:
		return -1
	
	var time = (
		%BGM.get_playback_position() +
		AudioServer.get_time_since_last_mix() -
		AudioServer.get_output_latency()
	)
	return round(time * 1000)

func _get_interval(curr_turn : int) -> Array[int]: # by ms
	curr_turn = clamp(curr_turn, 0, time_array.size() - 1)
	var mid_time := time_array[curr_turn]
	var left_time := mid_time - DEFAULT_UNIT
	var right_time := mid_time + DEFAULT_UNIT
	if curr_turn != 0:
		left_time = (time_array[curr_turn - 1] + time_array[curr_turn]) / 2
	mid_time = time_array[curr_turn]
	if curr_turn != time_array.size() - 1:
		right_time = (time_array[curr_turn + 1] + time_array[curr_turn]) / 2
	return [left_time, mid_time, right_time]

func get_time_array_data(path : String) -> Array[int]:
	var new_time_array : Array[int] = []
	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var value_str_array := content.split(",")
	for value_str in value_str_array:
		new_time_array.append(int(value_str))
	return new_time_array

func _on_start_music_toggled(toggled_on : bool) -> void:
	if toggled_on:
		start_music()
	else:
		pass

# 4 beat counting, then start music
func start_music() -> void:
	GlobalPause.self_detection = false
	await $Four_Beat_Helper.wait_four_beats()
	set_process(true)
	%BGM.play()
	GlobalPause.self_detection = true

func _process(_delta) -> void:
	if no_beat:
		return
	
	# update beatbar
	var time = _get_time_ms()
	%BeatBar_GUI.update_visuals(time)
	
	if _check_timeout():
		%Turn.turn()
	
	if _get_interval(beat_count)[MID] < time:
		beat_count += 1

func _check_timeout() -> bool:
	var curr_turn = %Turn.curr_turn
	if no_beat:
		return false
	var time := _get_time_ms()
	var interval := _get_interval(curr_turn)
	if curr_turn == gongbad_turn:
		return interval[MID] < time
	else:
		return interval[RIGHT] < time

# returns [valid : bool, precision : int]
func is_valid_input(curr_turn : int) -> Array:
	if no_beat:
		return [true, 0]
	
	var time := _get_time_ms()
	var interval := _get_interval(curr_turn)
	var precision := time - interval[MID]
	var valid : bool = false
	var is_gongbad : bool = false
	
	if curr_turn != gongbad_turn:
		if time < interval[LEFT]:
			gongbad_turn = curr_turn
			valid = false
			is_gongbad = true
		elif time < interval[RIGHT]:
			valid = true
	return [valid, precision, is_gongbad]
