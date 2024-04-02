extends Resource
class_name CharacterData

const PATH : String = "res://temporary_data/character_data.tres"

@export var max_hp : int = 100
@export var hp : int = 100
@export var max_energy : int = 12
@export var starting_energy : int = 3
var energy = starting_energy
var defense : int = 0
@export var defense_expire_rate : int = 4
@export var emergency_reload_many : int = 3

@export var deck : Array[Card] = []
@export var relic : Array[Relic] = []

func save() -> void:
	ResourceSaver.save(self, PATH)

func load() -> CharacterData:
	if not ResourceLoader.exists(PATH):
		save()
	return ResourceLoader.load(PATH)

# Character functions

