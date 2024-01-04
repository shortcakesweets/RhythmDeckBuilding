extends Node2D

@export var enemy_data_raw : Enemy = null
var enemy_data : Enemy = null

@onready var sprite = $sprite
@onready var turn_counter_label = $turn_counter
@onready var hp_bar = $HP
@onready var defend_label = $Defend
@export var appear_turn : int = 0

func _ready() -> void:
	set_values_from_resource()

func set_values_from_resource(new_resource : Enemy = null) -> void:
	if new_resource != null:
		enemy_data_raw = new_resource
	if enemy_data_raw != null:
		enemy_data = enemy_data_raw.duplicate(true)
	draw_enemy()

func draw_enemy() -> void:
	if enemy_data == null:
		self.visible = false
	else:
		enemy_data.set_FSM_data()
		self.visible = true
		var idle_animation : String = enemy_data.enemy_name.to_lower() + "_idle"
		sprite.play(idle_animation)
		update_visuals()

func update_visuals() -> void:
	turn_counter_label.text = str(enemy_data.get_current_state_counter())
	hp_bar.max_value = enemy_data.max_hp
	hp_bar.value = enemy_data.hp
	hp_bar.get_node("HP_label").text = str(enemy_data.hp) + " / " + str(enemy_data.max_hp)

func turn() -> Dictionary:
	var effect := {}
	if enemy_data != null:
		if enemy_data.hp <= 0:
			# add Death anim later
			set_values_from_resource()
		else:
			effect = enemy_data.turn()
			update_visuals()
	return effect
