extends Node

# All effects that needs character data will be implemented here
var character_data : CharacterData = null

func setup(raw_data : CharacterData) -> CharacterData:
	if raw_data == null:
		return
	character_data = raw_data.duplicate(true)
	return character_data
