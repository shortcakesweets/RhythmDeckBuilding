extends Node2D

var data : Enemy = null
@onready var visual = $Enemy

# Simple button-visible functions
func _on_load_fsm_pressed():
	$FileDialog_FSM.visible = true

# Simple button-visible functions
func _on_load_enemy_pressed():
	$FileDialog_load.visible = true

# Simple button-visible functions
func _on_save_enemy_as_pressed():
	$FileDialog_save.visible = true

func data_to_visual() -> void:
	visual.set_values_from_resource(data)
	$Control/enemy_name.text = data.enemy_name
	$Control/max_hp.value = data.max_hp
	$Control/fsm_path.text = data.FSM_path

func visual_to_data() -> void:
	if data == null:
		data = Enemy.new()
	data.enemy_name = $Control/enemy_name.text
	data.max_hp = $Control/max_hp.value

func _on_file_dialog_fsm_file_selected(path) -> void:
	if data == null:
		data = Enemy.new()
	data_to_visual()
	data.FSM_path = path
	$Control/fsm_path.text = path

func _on_file_dialog_save_file_selected(path) -> void:
	visual_to_data()
	ResourceSaver.save(data, path)

func _on_file_dialog_load_file_selected(path) -> void:
	data = load(path).duplicate(true)
	data_to_visual()
