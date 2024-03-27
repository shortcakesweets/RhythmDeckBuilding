extends Node2D

func _ready() -> void:
	self.visible = false
	$TextureProgressBar.value = 0

func update_visuals(enemy_data : Enemy) -> void:
	if enemy_data == null:
		self.visible = false
	else:
		self.visible = true
		$TextureProgressBar.max_value = enemy_data.max_hp
		$TextureProgressBar.value = enemy_data.hp
		$TextureProgressBar/Label.text = str(enemy_data.hp)
		$AnimatedSprite2D.play(enemy_data.enemy_animation)
		%Turn_Counter.text = str(enemy_data.AI.turn_counter)
