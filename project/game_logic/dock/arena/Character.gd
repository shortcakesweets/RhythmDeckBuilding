extends Node

var character_data : CharacterData = null
var defense_expire_count : int = 4
var defense_expire_proof : bool = false

func _ready() -> void:
	pass

func set_character_data(raw_character_data : CharacterData) -> void:
	if raw_character_data == null:
		return
	character_data = raw_character_data.duplicate(true)
	defense_expire_count = character_data.defense_expire_rate

func change_hp(diff : int) -> void:
	print(character_data.hp)
	character_data.hp = clamp(character_data.hp + diff, 0, character_data.max_hp)

func add_defense(diff : int) -> void:
	character_data.defense = clamp(character_data.defense + diff, 0, 999)
	defense_expire_count = character_data.defense_expire_rate
	defense_expire_proof = true

func decay_defense() -> void:
	if defense_expire_proof or character_data.defense == 0:
		defense_expire_proof = false
		return
	
	if defense_expire_count == 0:
		character_data.defense = 0
	else:
		defense_expire_count -= 1

func recieve_attack(attack : int) -> void:
	if attack <= 0:
		return
	if character_data.defense < attack:
		attack -= character_data.defense
		change_hp(-attack)
	character_data.defense = 0
