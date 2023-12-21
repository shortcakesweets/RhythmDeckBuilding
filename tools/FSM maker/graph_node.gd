extends GraphNode
const TYPE : int = 0
@onready var pin := [$Weight1, $Weight2, $Weight3, $Weight4, $Weight5]
var state_name : String = ""
var prep_time : int = 1

var weight : Array[float] = [0,0,0,0,0]
var recursive_weight : float = 0

func _on_delete_request() -> void:
	queue_free()

func _on_state_name_text_changed(new_text : String) -> void:
	state_name = new_text
	if state_name != "":
		self.title = state_name
	else:
		self.title = "State"

func _on_weight_box_value_changed(value : int, index : int) -> void:
	weight[index] = value
	var sum_weight := 0
	for w in weight:
		sum_weight += w
	recursive_weight = 100 - sum_weight
	$Recursive/value.text = str(recursive_weight) + "%"

func get_weight_on_port(port : int) -> float:
	return weight[port - 1]

func _on_wait_count_value_changed(value):
	prep_time = value

