extends Resource
class_name CharacterData

const PATH : String = "user://character_data.tres"

@export var max_hp : int = 100
@export var hp : int = 100
@export var max_energy : int = 12
var defense : int = 0
@export var defense_expire_rate : int = 4

@export var deck : Array[Card] = []
@export var init_buff_list : Array[Buff] = []
var buff_list : Array[Buff] = []

func save() -> void:
	ResourceSaver.save(self, PATH)

func load() -> Resource:
	if not ResourceLoader.exists(PATH):
		save()
	return load(PATH)

func has_buff(buff_name : String) -> bool:
	for buff in buff_list:
		if buff.buff_name == buff_name:
			return true
	return false
