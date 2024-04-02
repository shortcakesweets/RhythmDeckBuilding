extends Node

var character_data : CharacterData = null

func set_character_data(raw_data : CharacterData) -> void:
	if raw_data == null:
		return
	character_data = raw_data.duplicate(true)
	
