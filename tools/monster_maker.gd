extends Node2D

@onready var enemy_visual = $Enemy
@onready var selector = $UI/saveload/ScrollContainer/Selector
const PATH := "res://enemy/resource_files/"

func _ready():
	reload_selector_ui()

