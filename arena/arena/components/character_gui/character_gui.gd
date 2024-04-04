extends Node2D
@onready var anim = $Sprite

var tween_hp : Tween
var tween_defense : Tween

func update_visuals() -> void:
	var character_data : CharacterData = %Character.character_data
	if character_data == null:
		return
	
	_animate_character(character_data)
	_animate_hp(character_data)
	_animate_defense(character_data)
	_animate_buffs(character_data)
	
	# initialize character animation
	character_data.current_animation = "Sword_Idle"

func _animate_character(character_data : CharacterData) -> void:
	var anim_name : String = character_data.current_animation
	$Sprite.stop()
	$Sprite.play(anim_name)

func _animate_hp(character_data : CharacterData, tween_duration : float = 0.2) -> void:
	$HP.max_value = character_data.max_hp
	var final_value : int = character_data.hp
	if tween_hp:
		tween_hp.kill()
	tween_hp = create_tween()
	tween_hp.tween_property($HP, "value", final_value, tween_duration).set_trans(Tween.TRANS_EXPO)
	$HP/Label.text = str(character_data.hp)

func _animate_defense(character_data : CharacterData, tween_duration : float = 0.2) -> void:
	# for seamless animation, Defense max value is fixed as 100
	# and expire rate is calculated as ratio of expire/max_expire (%)
	var expire_rate := 0
	# $Defense.max_value = character_data.max_defense_expire_rate
	if character_data.defense > 0:
		#expire_rate = character_data.defense_expire_rate
		expire_rate = float(character_data.defense_expire_rate) / character_data.max_defense_expire_rate * 100
	
	if tween_defense:
		tween_defense.kill()
	tween_defense = create_tween()
	tween_defense.tween_property($Defense, "value", expire_rate, tween_duration).set_trans(Tween.TRANS_EXPO)
	$Defense/Label.text = str(character_data.defense)

func _animate_buffs(character_data : CharacterData) -> void:
	$Buffs_GUI.update_visuals(character_data.buff_list)
