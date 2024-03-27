# 슬라임
# - 4박마다 6딜을 넣는다.

static var turn_counter : int = 4

static func turn(arena : Node) -> void:
	turn_counter -= 1
	if(turn_counter == 0):
		turn_counter = 4
		_attack(arena)

static func _attack(arena) -> void:
	var character : Node = arena.get_node("%Character")
	character.recieve_attack(6)
