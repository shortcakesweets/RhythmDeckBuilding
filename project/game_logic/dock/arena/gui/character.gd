extends Node2D
@onready var anim = $Sprite

func play_animation_once(anim_name : String) -> void:
	anim.stop()
	anim.play(anim_name)

func play_attack_animation():
	var anim_name = ["Sword_Stab", "Sword_Attack"].pick_random()
	play_animation_once(anim_name)
