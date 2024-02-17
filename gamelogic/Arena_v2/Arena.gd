extends Node2D

@export var wave : Wave = null
@onready var character = $"%Character/Character"
@onready var rhythm = %Rhythm
@onready var enemies = %Enemies
@onready var BGM = %BGM
@onready var turn = %Turn
@onready var deck = %Deck

func _ready() -> void: 
	reload()

func reload() -> void:
	character.update_visuals(deck.shuffle_energy, deck.shuffle_energy_max)
	if wave != null:
		rhythm.offset = wave.music_offset
		rhythm.bpm = wave.bpm
		BGM.stream = wave.music
		
		enemies.enemy_spawn_info = wave.enemy_info
	
	rhythm._ready()

func _on_turn_stop_arena(is_win : bool) -> void:
	# 1. Show "PostArena", so that any clickable UI from game are banned
	pass
	
	# 2. Stop rhythm, turn logic.
	# Because of fadeout duration, this process takes 1.5 sec duration (default)
	turn.set_process_unhandled_key_input(false)
	rhythm.kill_process_and_fade_out()
	
	# 3. Show screen
	if is_win:
		pass
