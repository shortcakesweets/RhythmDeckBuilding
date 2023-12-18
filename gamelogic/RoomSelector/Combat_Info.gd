extends Control

@onready var label_metadata_key = $Metadata_Key
@onready var label_metadata_value = $Metadata_Value

func _ready():
	set_metadata()

func set_metadata(metadata : Dictionary = {}) -> void:
	label_metadata_key.text = ""
	label_metadata_value.text = ""
	
	var keys = metadata.keys()
	for key in keys:
		label_metadata_key.text += key + "\n"
		label_metadata_value.text += String(metadata[key]) + "\n"

func _on_fight_mouse_entered():
	$ColorSwap.visible = true

func _on_fight_mouse_exited():
	$ColorSwap.visible = false

func _unhandled_input(event):
	if event.is_action_pressed("cancel"):
		self.visible = false

func _on_esc_pressed():
	self.visible = false
