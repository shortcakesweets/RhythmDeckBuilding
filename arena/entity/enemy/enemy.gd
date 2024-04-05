extends Entity
class_name Enemy

@export var name : String = ""

@export var animation_idle : String = ""
@export var animation_death : String = ""
@export var animation_postdeath : String = ""
var current_animation : String = animation_idle
@export var current_icon : CompressedTexture2D = null

@export var turn_counter : int = 0

# Enemy acts
var was_dead : bool = false
func turn(_arena) -> void:
	if not is_dead():
		current_animation = animation_idle
	elif is_dead() and not was_dead:
		current_animation = animation_death
		was_dead = true
	else:
		current_animation = animation_postdeath
