extends Resource
class_name Enemy

@export var enemy_name := ""
@export var max_hp : int = 10
var hp : int = 10
var defend : int = 0
#@export var buffs : Dictionary = {}
#@export var id : int = 0

@export var FSM_path : String
var FSM : FiniteStateMachine = null

func set_FSM_data() -> void:
	if ResourceLoader.exists(FSM_path):
		FSM = load(FSM_path).duplicate(true)
		hp = max_hp
	else:
		printerr("Critical : FSM data not found")

func turn() -> Dictionary:
	var effect : Dictionary = FSM.turn()
	return effect

func get_current_state() -> String:
	return FSM.current_state

func get_current_state_counter() -> int:
	return FSM.current_state_counter
