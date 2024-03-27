extends Node2D
@onready var anim = $Sprite

func play_animation_once(anim_name : String) -> void:
	anim.stop()
	anim.play(anim_name)

func play_attack_animation():
	var anim_name = ["Sword_Stab", "Sword_Attack"].pick_random()
	play_animation_once(anim_name)

func update_visuals() -> void:
	var character_data : CharacterData = %Character.character_data
	
	if character_data == null:
		return
	$TextureProgressBar.max_value = character_data.max_hp
	$TextureProgressBar.value = character_data.hp
	$TextureProgressBar/Label.text = str(character_data.hp)
	
	# update defense visuals
	var defense = character_data.defense
	$Shield/Label.text = str(defense)
	
	$Buffs_GUI.update_visuals(character_data.buff_list)

