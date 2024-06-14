extends Entity
class_name CharacterData

const PATH : String = "res://temporary_data/character_data.tres"

@export var max_energy : int = 12
@export var starting_energy : int = 3
var energy = starting_energy
@export var max_defense_expire_rate : int = 4
var defense_expire_rate : int = max_defense_expire_rate
var defense_applied_this_turn : bool = false

@export var emergency_reload_many : int = 3
@export var reload_threshold : int = 8

@export var deck : Array[Card] = []
@export var relic : Array[Relic] = []

var current_animation : String = "Sword_Idle"

func save() -> void:
	ResourceSaver.save(self, PATH)

func load() -> CharacterData:
	if not ResourceLoader.exists(PATH):
		save()
	return ResourceLoader.load(PATH)

# updates defense += value
#  automatically updates expire rate
func apply_defense(value : int, is_renewal : bool = true) -> void:
	super.apply_defense(value)
	if is_renewal:
		defense_applied_this_turn = true
		defense_expire_rate = max_defense_expire_rate

func decay_defense_expire_rate() -> void:
	if defense_applied_this_turn:
		defense_applied_this_turn = false
		return
	
	defense_expire_rate -= 1
	if defense_expire_rate == 0:
		apply_defense(-defense)

func apply_energy(value : int) -> void:
	energy = clamp(energy + value, 0, max_energy)
