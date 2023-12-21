extends Node2D

@onready var graph = $GraphEdit
var initial_offset := Vector2(40,40)
var offset_delta := Vector2(20, 20)
var graph_node = preload("res://tools/FSM maker/graph_node.tscn")
var effect_node = preload("res://tools/FSM maker/graph_node_effect.tscn")

var node_index : int = 0

func _on_add_state_pressed():
	var new_node = graph_node.instantiate()
	new_node.position_offset = initial_offset + node_index * offset_delta
	graph.add_child(new_node)
	node_index += 1

func _on_add_effect_pressed():
	var new_node = effect_node.instantiate()
	new_node.position_offset = initial_offset + node_index * offset_delta
	graph.add_child(new_node)
	node_index += 1

func _on_graph_edit_connection_request(from_node, from_port, to_node, to_port):
	var connection_list = graph.get_connection_list()
	for c in connection_list:
		if c["from_node"] == from_node and c["from_port"] == from_port:
			graph.disconnect_node(from_node, from_port, c["to_node"], c["to_port"])
	#print(from_node, " ", from_port)
	#print(to_node, " ", to_port)
	graph.connect_node(from_node, from_port, to_node, to_port)

func load_resource(path) -> Resource:
	if ResourceLoader.exists(path):
		return load(path)
	return null

func _on_clear_graph_pressed():
	for node in graph.get_children():
		node.queue_free()
