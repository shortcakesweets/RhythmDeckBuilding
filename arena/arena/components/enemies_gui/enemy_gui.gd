extends Node2D

var tween : Tween

func _ready() -> void:
	self.visible = false
	$HP.value = 0

func update_visuals(enemy_data : Enemy, override_idle_anim : bool = false) -> void:
	if enemy_data == null:
		self.visible = false
	else:
		self.visible = true
		_animate_hp(enemy_data)
		_animate_buffs(enemy_data)
		
		$EnemySprite.stop()
		if not override_idle_anim:
			$EnemySprite.play(enemy_data.current_animation)
		else:
			$EnemySprite.play(enemy_data.animation_idle)
		%Turn_Counter.text = str(enemy_data.turn_counter)

func _animate_hp(enemy_data : Enemy, tween_duration : float = 0.2) -> void:
	$HP.max_value = enemy_data.max_hp
	var final_value : int = enemy_data.hp
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($HP, "value", final_value, tween_duration).set_trans(Tween.TRANS_EXPO)
	$HP/Label.text = str(enemy_data.hp)

func _animate_buffs(enemy_data : Enemy) -> void:
	var buff_list : Array[Buff] = []
	if not enemy_data.is_dead():
		buff_list = enemy_data.buff_list
	$Buffs_GUI.update_visuals(buff_list)
