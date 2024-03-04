extends Node2D

signal mouse_left_click(node_data : MapNode)

enum ROOM_TYPE {MONSTER, EVENT, ELITE, REST, SHOP, TREASURE, BOSS, NONE = -1}
const icon_treasure = preload("res://assets/gui/map_icons/chest.png")
const icon_elite = preload("res://assets/gui/map_icons/elite.png")
const icon_event = preload("res://assets/gui/map_icons/event.png")
const icon_monster = preload("res://assets/gui/map_icons/monster.png")
const icon_rest = preload("res://assets/gui/map_icons/rest.png")
const icon_shop = preload("res://assets/gui/map_icons/shop.png")

const color_normal := Color8(32, 32, 32)
const color_hover := Color8(32, 255, 32)
const color_valid := Color8(32, 255, 255)
const color_cleared := Color8(255, 128, 128)
var color_default = color_normal
var clickable : bool = false

var node_data : MapNode = null

@onready var sprite : Sprite2D = $Sprite

func set_node_data(node_data_ : MapNode) -> void:
	node_data = node_data_
	_set_sprite()
	_set_color()

func _set_sprite() -> void:
	match node_data.room_type:
		ROOM_TYPE.MONSTER:
			sprite.texture = icon_monster
		ROOM_TYPE.EVENT:
			sprite.texture = icon_event
		ROOM_TYPE.ELITE:
			sprite.texture = icon_elite
		ROOM_TYPE.REST:
			sprite.texture = icon_rest
		ROOM_TYPE.SHOP:
			sprite.texture = icon_shop
		ROOM_TYPE.TREASURE:
			sprite.texture = icon_treasure

func _set_color() -> void:
	if clickable:
		color_default = color_valid
	elif node_data.cleared:
		color_default = color_cleared
	sprite.self_modulate = color_default

func _on_mouse_detect_mouse_entered():
	sprite.scale = Vector2(1.2, 1.2)
	if clickable:
		sprite.self_modulate = color_hover

func _on_mouse_detect_mouse_exited():
	sprite.scale = Vector2(1.0, 1.0)
	sprite.self_modulate = color_default

func _on_mouse_detect_gui_input(event):
	if clickable and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("mouse_left_click", node_data)
