extends Node2D

#const PATH_MUSIC := "res://assets/music/"
#var SUB_PATH := "sample_music.txt"

@onready var rhythm := %Rhythm
var bar_preload := preload("res://game_logic/dock/arena/gui/beatbar/bar.tscn")
var bar_freeing_preload := preload("res://game_logic/dock/arena/gui/beatbar/bar_freeing.tscn")

func _ready() -> void:
	pass

# Deprecated
#static func set_beatbar_data(path : String) -> Array[int]:
	#var new_time_array : Array[int] = []
	#var file = FileAccess.open(path, FileAccess.READ)
	#var content = file.get_as_text()
	#file.close()
	#var value_str_array := content.split(",")
	#for value_str in value_str_array:
		#new_time_array.append(int(value_str))
	#return new_time_array

# render beatbar at "time".
#  - Removes beats that are faster (smaller) than time_array[beat_count], or if that beat is used by %Turn
var prev_time : int = -10000
func update_visuals(time : int) -> void:
	var time_array : Array[int] = %Rhythm.time_array
	for bar_child in $Bars.get_children():
		var is_gongbad : bool = false
		if %Rhythm.gongbad_turn != -1:
			is_gongbad = (bar_child.bar_time == time_array[%Rhythm.gongbad_turn])
		
		var is_early_input : bool = false
		if %Turn.curr_turn < time_array.size():
			is_early_input = (bar_child.bar_time < time_array[%Turn.curr_turn])
		
		if bar_child.bar_time < time:
			free_bar(bar_child, false)
		elif is_early_input or is_gongbad:
			free_bar(bar_child, true)
		else:
			bar_child.update_visuals(time)
	
	# add rendering node until possible : Deprecated
	#bar_children = $Bars.get_children()
	#var last_beat_bar_time : int = -1
	#if not bar_children.is_empty():
		#last_beat_bar_time = bar_children[-1].bar_time
	#for next_render in range(beat_count, time_array.size()):
		#if time_array[next_render] <= last_beat_bar_time:
			#continue
		#var new_bar := bar_preload.instantiate()
		#if new_bar.calc_distance(time) < new_bar.FADE_IN_START:
			#$Bars.add_child(new_bar)
			#new_bar.bar_time = time_array[next_render]
			#new_bar.update_visuals(time)
		#else:
			#break
	
	# debug
	#print(Bars.get_child_count())

func free_bar(bar : Node2D, animate : bool) -> void: # animate freeing-node
	if animate:
		var new_bar_freeing := bar_freeing_preload.instantiate()
		$Bars_Freeing.add_child(new_bar_freeing)
		new_bar_freeing.set_distance(bar.distance)
		new_bar_freeing.animate_freeing()
	bar.queue_free()

func set_bars(time_array : Array[int]) -> void:
	clear()
	for time in time_array:
		var new_bar := bar_preload.instantiate()
		$Bars.add_child(new_bar)
		new_bar.bar_time = time
	print($Bars.get_child_count())

func clear() -> void:
	for bar_child in $Bars.get_children():
		bar_child.queue_free()
