extends Node2D

const shader_material := preload("res://game_logic/dock/arena/gui/beatbar/bar_freeing_shader_material.tres")
const DEFAULT_TWEEN_DURATION := 0.3

func _ready() -> void:
	apply_shader_material()

func apply_shader_material() -> void:
	$Bar_Left.material = shader_material.duplicate()
	$Bar_Right.material = $Bar_Left.material

func animate_freeing(tween_duration : float = DEFAULT_TWEEN_DURATION) -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(_apply_shader_param, 0.8, 0.0, tween_duration)
	tween.tween_callback(self.queue_free)

func _apply_shader_param(alpha : float) -> void:
	var shader : ShaderMaterial = $Bar_Left.material
	shader.set_shader_parameter("alpha", alpha)

func set_distance(distance : float) -> void:
	$Bar_Left.position.x = -distance
	$Bar_Right.position.x = distance
