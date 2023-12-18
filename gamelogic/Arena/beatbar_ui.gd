extends Node2D

@onready var hit_sprite = $hit_sprite
@onready var idle_sprite = $idle_sprite
@export var hit_speed = 4.0

func _ready() -> void:
	hit_sprite.speed_scale = hit_speed
	$Icon.visible = false

func set_idle_speed_by_bpm(bpm : float) -> void:
	###### IMPORTANT ######
	# "idle_animation_frame_count" value is manually constructed
	# thus should be modified when idle animation is changed
	var idle_animation_frame_count : int = 6
	var loop_time := float(idle_animation_frame_count) / 5.0
	
	# loop time should match unit := 60/bpm (seconds)
	idle_sprite.speed_scale = loop_time * bpm / 60.0

func play_idle() -> void:
	idle_sprite.stop()
	idle_sprite.play("idle")

func play_hit() -> void:
	hit_sprite.stop()
	var animation_name = "hit_animation_" + str(Rng.rng.randi_range(1,4))
	hit_sprite.play(animation_name)
	print(animation_name)
