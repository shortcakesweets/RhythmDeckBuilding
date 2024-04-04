extends Node

var curr_turn : int = 0

enum KEY_CODE {
	NO_INPUT = -2,
	DEFAULT = -1,
	RELOAD = 10
}

func turn(card_idx : int = -1) -> void:
	var arena := $"../.."
	var character_data : CharacterData = %Character.character_data
	
	# 1. Handle card usage
	match card_idx:
		KEY_CODE.RELOAD:
			%Deck.reload_regarding_energy()
		KEY_CODE.DEFAULT:
			pass
		_:
			%Deck.use_card(card_idx)
	
	# 2. Enemy turn
	%Enemies.turn_all()
	
	# 3. Invoke hand cards
	%Deck.on_turn_end()
	
	# 4. decay character defense
	character_data.decay_defense_expire_rate()
	
	# 5. buff decay
	character_data.decay_buffs(arena)
	%Enemies.decay_buffs_all(arena)
	
	# 6. animate character, deck and so on
	%Character_GUI.update_visuals()
	%Deck_GUI.update_visuals(self)
	curr_turn += 1
