extends Control

@onready var enter_box := $Enter
@onready var Map := $".."
var node_data : MapNode = null

func set_room_data(node_data_ : MapNode) -> void:
	node_data = node_data_
	# WIP

func _on_enter_detect_mouse_detected(is_focused : bool) -> void:
	enter_box.visible = is_focused

func _on_enter_detect_gui_input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not event.is_echo():
			Map.map_data.visit_at(Vector2(node_data.floor, node_data.col))
			# debug option
			Map.emit_signal("start_room", node_data)

func _on_exit_detect_gui_input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			self.visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		self.visible = false
