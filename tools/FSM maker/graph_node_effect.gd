extends GraphNode
const TYPE : int = 1
@onready var template = $effect_template

func _ready() -> void:
	pass

func _on_add_effect_pressed():
	var node = template.duplicate(DUPLICATE_GROUPS)
	add_child(node)
	move_child(node, -3)
	node.visible = true

func parse_effect_as_dictionary() -> Dictionary :
	var effect : Dictionary = {}
	var child_count : int = self.get_child_count()
	for i in range(1, child_count-2):
		var node := self.get_child(i)
		var effect_name : String = node.get_node("LineEdit").text
		var effect_value : int = node.get_node("value").value
		if effect_value != 0:
			effect[effect_name] = effect_value
	return effect
