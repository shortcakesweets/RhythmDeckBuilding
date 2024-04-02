extends Node2D

@export var debug_mode : bool = false
@export var debug_character_data : CharacterData = null
@export var debug_wave_data : String = "Not Implemented"

var character_data : CharacterData = CharacterData.new()

func _ready() -> void:
	if debug_mode and debug_character_data != null:
		character_data = debug_character_data.duplicate(true)
	else:
		character_data = character_data.load().duplicate(true)
	
	%Deck.setup(character_data)
