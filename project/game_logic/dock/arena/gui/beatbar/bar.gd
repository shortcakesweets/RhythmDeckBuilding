@tool
extends Node2D

const BAR_SPEED : float = 400 # px/s
const FADE_IN_START : float = 600 #px
const FADE_IN_END : float = 550 #px
const UNRENDER_DISTANCE : float = -1 #px

const shader_code = preload("res://game_logic/dock/arena/gui/beatbar/bar.gdshader")

enum VisualEffect {NONE, CPU, SHADER}
@export var effect_option : VisualEffect = VisualEffect.SHADER
@export var distance : float = 0 # px
var bar_time : int = 0 # ms
var alpha : float = 1.0

func _ready() -> void:
	if effect_option == VisualEffect.SHADER:
		apply_shader_material()

func apply_shader_material() -> void:
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader_code
	$Bar_Left.material = shader_material
	$Bar_Right.material = $Bar_Left.material

func update_visuals(curr_time : int) -> void:
	distance = calc_distance(curr_time)
	alpha = calc_visibility()
	
	_apply_distance()
	match effect_option:
		VisualEffect.CPU:
			_apply_visibility()
		VisualEffect.SHADER:
			_apply_shader_param()
		_:
			pass

func calc_distance(curr_time : int) -> float:
	return float(bar_time - curr_time) * 0.001 * BAR_SPEED

func calc_visibility() -> float:
	if distance < UNRENDER_DISTANCE:
		return 0.0
	else:
		return clamp((distance - FADE_IN_START) / (FADE_IN_END - FADE_IN_START), 0.0, 1.0)

func _apply_distance() -> void:
	$Bar_Left.position.x = -distance
	$Bar_Right.position.x = distance

func _apply_shader_param() -> void:
	$Bar_Left.material.set_shader_parameter("alpha", alpha)
	# Bar right's material is referenced by left

# Deprecated
func _apply_visibility() -> void:
	$Bar_Left.self_modulate.a = alpha
	$Bar_Right.self_modulate.a = alpha

# @tool
func _process(delta) -> void:
	if Engine.is_editor_hint():
		_apply_distance()
		#_apply_shader_param()
