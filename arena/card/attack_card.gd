extends Card
class_name CardAttack

@export var damage : int = 0
@export var strength_multiplier : int = 1

# Override
func on_use(arena : Node) -> void:
	pass
