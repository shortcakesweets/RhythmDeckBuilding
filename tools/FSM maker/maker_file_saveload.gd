extends Node2D

@onready var graph = $"../editor/GraphEdit"
@onready var debug_label = $"../editor/StateData"
var last_load_path : String = ""

var data : FiniteStateMachine = null

func _on_save_pressed() -> void:
	if last_load_path != "":
		save_FSM_resource(last_load_path)

# Filemanager UI opener
func _on_save_as_pressed() -> void:
	$FileDialog_Save.visible = true

# Filemanager UI opener
func _on_load_pressed() -> void:
	$FileDialog_Load.visible = true

func _on_file_dialog_save_file_selected(path : String) -> void:
	save_FSM_resource(path)

func _on_file_dialog_load_file_selected(path) -> void:
	last_load_path = path
	load_FSM_resource(path)

func extract_node_data() -> Dictionary:
	var children_list = graph.get_children()
	var stringName_to_index : Dictionary = {}
	var i : int = 0
	for node in children_list:
		stringName_to_index[node.name] = i
		i+=1
	
	var state_list : Dictionary = {}
	for node in children_list:
		#if node.TYPE == 0:
			#state_list[node.state_name] = FiniteStateMachine.State.new(
				#node.state_name,
				#node.prep_time,
				#{},
				#{node.state_name : node.recursive_weight}
			#)
		if node.TYPE == 0:
			state_list[node.state_name] = {
				"prep_time" : node.prep_time,
				"effect" : {},
				"next_state" : {node.state_name : node.recursive_weight}
			}
	
	var connection_list = graph.get_connection_list()
	for c in connection_list:
		var node_from = graph.get_child(stringName_to_index[c["from_node"]])
		var node_to = graph.get_child(stringName_to_index[c["to_node"]])
		if node_to.TYPE == 1: # effect data
			#state_list[node_from.state_name].effect = node_to.parse_effect_as_dictionary()
			state_list[node_from.state_name]["effect"] = node_to.parse_effect_as_dictionary()
		else: # weight data
			var weight : int = int(node_from.get_weight_on_port(c["from_port"]))
			state_list[node_from.state_name]["next_state"][node_to.state_name] = weight
	
	return state_list

func save_FSM_resource(path) -> void:
	if data == null:
		data = FiniteStateMachine.new()
	data.state_list = extract_node_data()
	#data.graph_children_data = extract_graph_children_data().duplicate(true)
	data.graph_children_data.clear()
	for node in graph.get_children():
		data.graph_children_data.append(node.duplicate(7))
	data.graph_connection_data = graph.get_connection_list().duplicate(true)
	ResourceSaver.save(data, path)
	debug_print_resource_data()

# Resource -> GraphChildren, currently not used
func reconstruct_graph_data() -> void:
	for leftover_child in graph.get_children():
		leftover_child.queue_free()
	for node in data.graph_children_data:
		graph.add_child(node)
	for c in data.graph_connection_data:
		graph.connect_node(c["from_node"], c["from_port"], c["to_node"], c["to_port"])

func load_FSM_resource(path) -> void:
	if ResourceLoader.exists(path):
		data = load(path).duplicate(true) as FiniteStateMachine
		#reconstruct_graph_data()
		debug_print_resource_data()

func debug_print_resource_data() -> void:
	if data == null:
		print("null data")
		debug_label.text = "null data"
		return
	
	var state_textify := ""
	for key in data.state_list:
		#print(data.state_list[key])
		state_textify += "state_name: " + key + "\n"
		state_textify += " - prep_time : " + str(data.state_list[key]["prep_time"]) + "\n"
		state_textify += " - effect: " + str(data.state_list[key]["effect"]) + "\n"
		state_textify += " - next_state : " + str(data.state_list[key]["next_state"]) + "\n\n"
	debug_label.text = state_textify
	print(state_textify)
