extends "res://cards/card_effect.gd"
enum {DEBUG = 100, SHUFFLE = 200}
@onready var rhythm = %Rhythm
@onready var character = %Character
@onready var deck = %hand
@onready var beatbar = $Rhythm/CanvasLayer/Beatbar_UI
@onready var enemies = $Enemies
@onready var target_sprite = $Character/character/target_sprite

var curr_turn : int = 0
var curr_target : int = -1

# Auto checks and fixes "curr_target"
func check_curr_target() -> void:
	if curr_target == -1 or get_node("Enemies").get_child(curr_target).enemy_data == null:
		curr_target = -1
		for index in range(3):
			if get_node("Enemies").get_child(index).enemy_data != null:
				curr_target = index
				return

# Turn mechanics. will be branched later.
func turn(card_index : int = -1) -> void:
	# Run Player Card - wip
	var used_card_resource : Card = null
	if card_index != -1:
		used_card_resource = deck.use_card(card_index)
	if used_card_resource != null:
		character.play_attack_animation()
		CardEffect.apply_card_effect(used_card_resource, curr_target)
		pass
	else: # no card was selected
		#character.play_animation_once("Idle Sword")
		character.play_attack_animation()
	
	# check target_sprite animation & it's position
	check_curr_target()
	if curr_target != -1:
		var anim_pos = get_node("Enemies").get_child(curr_target).position
		target_sprite.position = anim_pos
		target_sprite.play("targeted")
	
	# Run Enemy Queue
	var effect_array : Array = enemies.turns()
	
	# update visuals
	character.update_visuals()
	
	# check win/lose traits
	
	# Run spawn Queue
	enemies.spawn(curr_turn)
	
	# increment turn count
	curr_turn += 1

# Checks timeout for this curr_turn
func _process(_delta) -> void:
	if rhythm.check_timeout(curr_turn):
		turn()
	
	# debug mod
	$"../Debug System/Label".text = "curr_turn : " + str(curr_turn)

# Checks input
func _unhandled_input(event : InputEvent) -> void:
	if event.is_echo():
		return
	rhythm_input(event)
	non_rhythm_input(event)

func rhythm_input(event : InputEvent) -> void:
	var card_selected : int = -1
	var shuffle_succeed : bool = false
	if event.is_action_pressed("select_card_1"):
		card_selected = 0
	elif event.is_action_pressed("select_card_2"):
		card_selected = 1
	elif event.is_action_pressed("select_card_3"):
		card_selected = 2
	elif event.is_action_pressed("select_card_4"):
		card_selected = 3
	elif event.is_action_pressed("select_card_5"):
		card_selected = 4
	elif event.is_action_pressed("select_card_6"):
		card_selected = 5
	elif event.is_action_pressed("beat_debug"):
		card_selected = DEBUG # debug mode
	elif event.is_action_pressed("shuffle"):
		shuffle_succeed = deck.use_shuffle()
		card_selected = SHUFFLE
	else:
		return
	
	if 0 <= card_selected and card_selected < 6:
		# Check valid input
		var card_validity : bool = (deck.cards[card_selected].card_resource_raw != null)
		var rhythm_validity = rhythm.is_valid_input(curr_turn)
		if card_validity and rhythm_validity[0]:
			turn(card_selected)
		$"../Debug System/precision".text = str(rhythm_validity[1]).left(5)
	elif card_selected == DEBUG:
		var rhythm_validity = rhythm.is_valid_input(curr_turn)
		if rhythm_validity[0]:
			turn()
		$"../Debug System/precision".text = str(rhythm_validity[1]).left(5)
	elif card_selected == SHUFFLE:
		var rhythm_validity = rhythm.is_valid_input(curr_turn)
		if rhythm_validity[0]:
			turn()
		$"../Debug System/precision".text = str(rhythm_validity[1]).left(5)

func non_rhythm_input(event : InputEvent) -> void:
	if event.is_action_pressed("target_change"):
		curr_target = (curr_target + 1) % 3
		check_curr_target()
