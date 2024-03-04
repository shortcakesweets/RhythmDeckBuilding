extends Resource
class_name CharacterData

const PATH : String = "user://character_data.tres"

@export var max_hp : int = 100
@export var hp : int = 100
@export var max_energy : int = 12

func save() -> void:
	ResourceSaver.save(self, PATH)

func load() -> Resource:
	if not ResourceLoader.exists(PATH):
		save()
	return load(PATH)
