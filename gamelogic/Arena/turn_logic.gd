extends "res://cards/card_effect.gd"
@onready var rhythm = $Rhythm
@onready var character = $Character
@onready var deck = $Character/deck_hand/hand
@onready var beatbar = $Rhythm/CanvasLayer/Beatbar_UI
@onready var enemies = $Enemies

var curr_turn : int = 0

func _ready() -> void:
	pass

func turn(card_index : int = -1) -> void:
	# Run Player Card - wip
	var used_card_id : int = -1
	if card_index != -1:
		used_card_id = deck.use_card(card_index)
	if used_card_id != -1:
		character.play_attack_animation()
		# Use card's effect
		pass
	else: # no card was selected
		#character.play_animation_once("Idle Sword")
		character.play_attack_animation()
	
	# Run Enemy Queue
	var effect_array : Array = enemies.turns()
	# check win/lose traits
	
	# increment turn count
	curr_turn += 1

# Checks timeout for this curr_turn
func _process(delta) -> void:
	if rhythm.check_timeout(curr_turn):
		turn()
	
	# debug mod
	$"../Debug System/Label".text = "curr_turn : " + str(curr_turn)

func _unhandled_input(event):
	if event.is_echo():
		return
	
	var card_selected : int = -1
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
		card_selected = 100 # debug mode
	
	if card_selected != -1 and card_selected != 100:
		# Check valid input
		var card_validity : bool = deck.cards[card_selected].card_id != -1
		var rhythm_validity = rhythm.is_valid_input(curr_turn)
		if card_validity and rhythm_validity[0]:
			turn(card_selected)
		$"../Debug System/precision".text = str(rhythm_validity[1]).left(4)
	elif card_selected == 100:
		var rhythm_validity = rhythm.is_valid_input(curr_turn)
		if rhythm_validity[0]:
			turn()
		$"../Debug System/precision".text = str(rhythm_validity[1]).left(5)
	
	if event.is_action_pressed("shuffle"):
		# check validity for shuffling - pass
		deck.draw_cards()

