extends Resource
class_name Buff

@export var buff_name := ""
@export var buff_description := ""
@export var buff_icon : CompressedTexture2D = null
@export var is_debuff : bool = false
@export var is_decayable : bool = true

@export var buff_apply_sfx : AudioStreamOggVorbis = preload("res://assets/sound/sample_buff.ogg")
@export var buff_end_sfx : AudioStreamOggVorbis = null

@export var buff_functions : Script = null
var buff_count : int = 0
var applied_turn : int = 0

# 버프를 받는 순간 일어날 일입니다.
func on_apply(arena : Node, target : Resource, count : int) -> void:
	SoundManager.play_sfx(buff_apply_sfx)
	applied_turn = arena.get_node("%Turn").curr_turn
	buff_count = count
	
	print("버프받은 턴:" + str(applied_turn))
	
	if buff_functions != null and buff_functions.has_method("on_apply"):
		buff_functions.on_apply(arena, target, self)
	else:
		target.buff_list.append(self)

# 턴 시작시, 버프 카운트를 1 줄입니다.
func on_decay(arena : Node, target : Resource) -> void:
	if buff_functions != null and buff_functions.has_method("on_decay"):
		buff_functions.on_decay(arena, target)
	
	if is_decayable:
		buff_count -= 1

# 버프 카운트가 0 이라 더이상 줄어들 수 없을 때, 일어나는 일입니다.
func on_decay_end(arena : Node, target : Resource) -> void:
	SoundManager.play_sfx(buff_end_sfx)
	if buff_functions != null and buff_functions.has_method("on_decay_end"):
		buff_functions.on_decay_end(arena, target)

# (버프를 가지고 있는 중) 턴 종료 후 일어날 일입니다.
#  버프가 부여된 턴에는 발생하지 않습니다. - 체크는 Turn에서 이루어짐 
func on_turn_end(arena : Node, target : Resource) -> void:
	if buff_functions != null and buff_functions.has_method("on_turn_end"):
		buff_functions.on_turn_end(arena, target)
