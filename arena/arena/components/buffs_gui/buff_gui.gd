extends TextureRect

func update_visuals(buff : Buff) -> void:
	self.texture = buff.buff_icon
	$Label.text = str(buff.buff_count)
