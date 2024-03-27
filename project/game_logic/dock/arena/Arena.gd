extends Node2D

signal back_to_map(win : bool)
signal back_to_main

@export var debug_wave_data : Wave = null
@export var debug_character_data : CharacterData = null

func _ready() -> void:
	await set_debug_data()
	%Rhythm.start_music()

func set_arena(node_data : MapNode, character_data : CharacterData) -> void:
	var wave_data = node_data.wave_data
	%BGM.stream = wave_data.bgm
	%Enemies.set_enemy_list(wave_data.enemy_list)
	%Enemies_GUI.update_visuals()
	%Character.set_character_data(character_data)
	%Character_GUI.update_visuals()
	
	# update character data - deck
	%Deck.setup_deck(character_data)

func set_debug_data() -> void:
	var node_data : MapNode = null
	var character_data : CharacterData = null
	
	if debug_wave_data != null:
		node_data = MapNode.new()
		node_data.wave_data = debug_wave_data
	if debug_character_data != null:
		character_data = debug_character_data
	
	set_arena(node_data, character_data)
