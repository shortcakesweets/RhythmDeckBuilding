extends ConfirmationDialog

var error_paths := []

func _on_confirmed():
	var dir_enemy := DirAccess.open("res://enemy/enemy_resource/")
	var dir_FSM := DirAccess.open("res://enemy/fsm_resource/")
	
	flawless_check_enemy(dir_enemy)
	flawless_check_FSM(dir_FSM)
	self.visible = false

func flawless_check_enemy(dir):
	pass

func flawless_check_FSM(dir):
	pass
