extends Resource
class_name FiniteStateMachine

@export var state_list : Dictionary = {}
var current_state := "start"
var current_state_counter : int = 1

class State:
	var state_name := ""
	var prep_time := 0
	var effect : Dictionary = {}
	var next_state : Dictionary = {}
	# Example : next_state = {"stateA" : 0.4, "stateB" : 0.6}
	
	func _init(state_name_ : String, prep_time_ : int, effect_ : Dictionary, next_state_ : Dictionary) -> void:
		state_name = state_name_
		prep_time = prep_time_
		effect = effect_
		next_state = next_state_

func turn() -> Dictionary:
	var effect : Dictionary = {}
	
	current_state_counter -= 1
	if current_state_counter <= 0:
		effect = state_list[current_state].effect
		
		var key_array : Array = state_list[current_state].next_state.keys()
		var weight_array := []
		for key in key_array:
			weight_array.append(state_list[current_state].next_state[key])
		var index : int = Rng.weighted_rng(weight_array)
		
		current_state = key_array[index]
		current_state_counter = state_list[current_state].prep_time
	
	return effect

func add_state(state_name : String, prep_time : int, effect : Dictionary, next_state : Dictionary) -> void:
	state_list[state_name] = State.new(state_name, prep_time, effect, next_state)

