extends Resource
class_name Enemy

@export var enemy_name := ""
@export var max_hp : int = 10
var hp : int = 10
var def : int = 0
@export var buffs : Dictionary = {}
@export var id : int = 0

@export var FSM : FiniteStateMachine = null

func turn() -> Dictionary:
	var effect : Dictionary = FSM.turn()
	return effect

func get_current_state() -> String:
	return FSM.current_state

func get_current_state_counter() -> int:
	return FSM.current_state_counter
