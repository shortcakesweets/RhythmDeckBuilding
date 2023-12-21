extends Node

@export var wave : Wave = null

func _ready() -> void: 
	reload()

func reload() -> void:
	if wave != null:
		$"Turn logic/Rhythm".offset = wave.music_offset
		$"Turn logic/Rhythm".bpm = wave.bpm
		$"Turn logic/Rhythm/AudioStreamPlayer".stream = wave.music
		
		$"Turn logic/Enemies".enemy_spawn_info = wave.enemy_info
	
	$"Turn logic/Rhythm"._ready()
	
