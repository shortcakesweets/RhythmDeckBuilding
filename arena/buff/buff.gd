extends Resource
class_name Buff

@export var buff_name : String = ""
@export var buff_icon : CompressedTexture2D = null
@export var buff_description : String = ""

@export var is_debuff : bool = false
@export var is_decaying : bool = true

var buff_count : int = 0

# Returns true is buff count was 0, and should be eliminated.
func decay(arena, entity : Entity) -> bool:
	if not is_decaying:
		_on_persist(arena, entity)
		return false
	
	buff_count -= 1
	if buff_count == 0:
		_on_buff_end(arena, entity)
		return true
	else:
		_on_persist(arena, entity)
		return false

# Returns if this buff can be applied to entity.
func is_applyable(arena, entity : Entity) -> bool:
	return true

# effect on apply
func on_apply(arena, entity : Entity) -> void:
	pass

# effect on persist
#  if is_decaying == false, always called.
func _on_persist(arena, entity : Entity) -> void:
	pass

# effect on buff end
func _on_buff_end(arena, entity : Entity) -> void:
	pass

