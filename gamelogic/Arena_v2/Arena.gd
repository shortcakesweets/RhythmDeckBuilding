extends Node2D

@export var wave : Wave = null
@onready var character = $"%Character/Character"
@onready var rhythm = %Rhythm
@onready var enemies = %Enemies
@onready var BGM = %BGM

func _ready() -> void: 
	reload()

func reload() -> void:
	character.update_visuals()
	if wave != null:
		rhythm.offset = wave.music_offset
		rhythm.bpm = wave.bpm
		BGM.stream = wave.music
		
		enemies.enemy_spawn_info = wave.enemy_info
	
	rhythm._ready()
