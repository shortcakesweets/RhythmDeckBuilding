extends Resource
class_name Enemy

@export var enemy_name : String = ""
@export var enemy_animation : String = ""
@export var max_hp : int = 100
@export var hp : int = 100
@export var defense : int = 0
@export var AI : Script = null

func turn(arena : Node) -> void:
	if AI.has_method("turn"):
		AI.turn(arena)

func is_dead() -> bool:
	return hp == 0

func change_hp(diff : int) -> void:
	hp = clamp(hp + diff, 0, max_hp)

func change_defense(diff : int) -> void:
	defense = clamp(defense + diff, 0, 999)

func recieve_attack(attack : int) -> void:
	if defense >= attack:
		defense -= attack
	elif defense < attack:
		defense = 0
		attack -= defense
		change_hp(-attack)
