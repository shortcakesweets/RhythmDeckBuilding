extends Node2D

@export var debug_mode : bool = false
@export var debug_character_data : CharacterData = null
@export var debug_wave_data : Wave = null

func _ready() -> void:
	var character_data : CharacterData = CharacterData.new()
	if debug_mode and debug_character_data != null:
		character_data = %Character.setup(debug_character_data)
	else:
		character_data = %Character.setup(character_data.load())
	%Deck.setup(character_data)
	
	if debug_mode and debug_wave_data != null:
		%Enemies.setup(debug_wave_data)
	
	%Character_GUI.update_visuals()
