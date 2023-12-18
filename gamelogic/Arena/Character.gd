extends Node
@onready var anim = $character/anim_sprite

func _ready():
	# anim.play("Idle Sword")
	pass

func set_speed_by_bpm(bpm : float) -> void:
	###### IMPORTANT ######
	# "idle_animation_frame_count" value is manually constructed
	# thus should be modified when idle animation is changed
	var idle_animation_frame_count : int = 9
	var loop_time := float(idle_animation_frame_count) / 5.0
	
	# loop time should match unit := 60/bpm (seconds)
	$character/anim_sprite.speed_scale = loop_time * bpm / 60.0

func play_animation_once(anim_name : String) -> void:
	anim.stop()
	anim.play(anim_name)

func play_attack_animation():
	var i := Rng.rng.randi_range(0,1)
	var anim_name := ""
	if i == 0:
		anim_name = "Sword Stab"
	else:
		anim_name = "Sword Swing"
	play_animation_once(anim_name)

################################################################
