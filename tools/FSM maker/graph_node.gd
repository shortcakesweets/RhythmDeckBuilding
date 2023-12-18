extends GraphNode

@onready var pin := [$Weight1, $Weight2, $Weight3, $Weight4, $Weight5]
var state_name : String = ""
var prep_time : int = 1
var effect : Dictionary = {}

var weight : Array[float] = [0,0,0,0,0]
var recursive_weight : float = 0

func _on_delete_request() -> void:
	queue_free()

func _on_state_name_text_changed(new_text : String) -> void:
	state_name = new_text

func _on_weight_box_value_changed(value : int, index : int) -> void:
	weight[index] = value

func get_weight_on_port(port) -> float:
	return weight[port]

func _on_wait_count_value_changed(value):
	prep_time = value

func _on_recursive_value_changed(value):
	recursive_weight = value
