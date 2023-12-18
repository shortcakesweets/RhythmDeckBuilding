extends Control
signal interact(floor, index)

enum MAP_TYPE {MONSTER, EVENT, ELITE, REST, SHOP, TREASURE, BOSS, NONE = -1}

var floor := 0
var index := 0
var type := MAP_TYPE.NONE
var visited := false

@onready var type_to_sprite = [$Monster, $Event, $Elite, $Rest, $Shop, $Treasure, $BossText]

func _ready():
	$Icon.visible = false
	$Button.self_modulate.a = 0

func draw_type(change_type : MAP_TYPE = MAP_TYPE.NONE) -> void:
	$Cross.visible = visited
	type = change_type
	for i in range(type_to_sprite.size()):
		type_to_sprite[i].visible = (type == i)

func _on_button_mouse_entered():
	$Circle.visible = true

func _on_button_mouse_exited():
	$Circle.visible = false

func _on_button_pressed():
	interact.emit(floor, index)
