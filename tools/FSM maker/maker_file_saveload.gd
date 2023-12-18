extends Node

@onready var root = $".."
@onready var graph = $"../editor/GraphEdit"
var last_load_path : String = ""

func _on_save_pressed() -> void:
	debug_print_state(extract_weight_data())
	if last_load_path == "":
		return
	ResourceSaver.save(root.data, last_load_path)

func _on_save_as_pressed() -> void:
	$FileDialog_Save.visible = true

func _on_load_pressed() -> void:
	$FileDialog_Load.visible = true

func _on_file_dialog_save_file_selected(path : String) -> void:
	ResourceSaver.save(root.data, path)

func _on_file_dialog_load_file_selected(path) -> void:
	last_load_path = path
	root.data = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE).duplicate(true)

func extract_weight_data() -> Dictionary:
	var state_list : Dictionary = {}
	var stringName_to_index : Dictionary = {}
	var i : int = 0
	for node in graph.get_children():
		state_list[node.state_name] = FiniteStateMachine.State.new(
			node.state_name,
			node.prep_time,
			node.effect,
			{node.state_name : node.recursive_weight}
		)
		stringName_to_index[node.name] = i
		i += 1
	
	var connection_list = graph.get_connection_list()
	for c in connection_list:
		var node_from = graph.get_child(stringName_to_index[c["from_node"]])
		var node_to = graph.get_child(stringName_to_index[c["to_node"]])
		var weight : float = node_from.get_weight_on_port(c["from_port"])
		state_list[node_from.state_name].next_state[node_to.state_name] = weight
	
	return state_list

func debug_print_state(state_list : Dictionary) -> void:
	for state_name in state_list:
		print(state_name)
		print(state_list[state_name].prep_time)
		#print(state_list[state_name].effect)
		print(state_list[state_name].next_state)
		print("____________________________________")
