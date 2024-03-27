extends Node2D

var hand_pile_gui : Array[Node2D] = []

var draw_pile_preview_gui : Array[Node2D] = []

func _ready() -> void:
	hand_pile_gui = [
	$Hand/Card_GUI0,
	$Hand/Card_GUI1,
	$Hand/Card_GUI2,
	$Hand/Card_GUI3,
	$Hand/Card_GUI4,
	$Hand/Card_GUI5]
	
	draw_pile_preview_gui = [
	$Card_GUI_prev0,
	$Card_GUI_prev1]

func update_visuals() -> void:
	var hand_pile : Array[Card] = %Deck.hand_pile
	var draw_pile : Array[Card] = %Deck.draw_pile
	var discard_pile : Array[Card] = %Deck.discard_pile
	var current_energy : int = %Deck.energy
	var is_parrying : bool = %Turn.parry_mode
	
	for i in range(6):
		#hand_pile_gui[i].update_visuals(hand_pile[i], current_energy, is_parrying)
		hand_pile_gui[i].update_card_info(hand_pile[i])
		hand_pile_gui[i].update_card_animation(hand_pile[i], current_energy, is_parrying)
	
	for i in range(2):
		var card_data = null
		if i < draw_pile.size():
			card_data = draw_pile[i]
		#draw_pile_preview_gui[i].update_visuals(card_data, -1, false)
		draw_pile_preview_gui[i].update_card_info(card_data)
