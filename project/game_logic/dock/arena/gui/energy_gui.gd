extends Node2D

@onready var progress_bar := $Control/TextureProgressBar as TextureProgressBar
@onready var value_label := $Control/Label_energy as Label

func _ready() -> void:
	pass

func change_energy_value(value : int) -> void:
	progress_bar.value = value
	value_label.text = str(value)

func change_energy_max_value(max_value : int) -> void:
	progress_bar.max_value = max_value
