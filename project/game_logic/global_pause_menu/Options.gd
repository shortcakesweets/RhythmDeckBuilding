extends Control

@onready var Video_Control = $Video
@onready var Music_Control = $Music
@onready var Video_Button = $SubOptions/Video
@onready var Music_Button = $SubOptions/Music

const RESOLUTION_OPTION : Array[Vector2] = [
	Vector2(1920, 1080),
	Vector2(1600, 900),
	Vector2(1280, 720)
]

var data : Options = Options.new()

func _ready() -> void:
	data = data.load()
	data_to_gui()
	apply_data()

func _on_video_toggled(_toggled_on : bool) -> void:
	if (not Video_Button.button_pressed) and (not Music_Button.button_pressed):
		Video_Button.button_pressed = true
	Music_Button.button_pressed = false
	Video_Control.visible = true
	Music_Control.visible = false

func _on_music_toggled(_toggled_on : bool) -> void:
	if (not Video_Button.button_pressed) and (not Music_Button.button_pressed):
		Music_Button.button_pressed = true
	Video_Button.button_pressed = false
	Video_Control.visible = false
	Music_Control.visible = true

func _on_v_sync_button_toggled(toggled_on : bool) -> void:
	if toggled_on:
		$Video/VSync_Button/Label.text = "ON"
	else:
		$Video/VSync_Button/Label.text = "OFF"

func gui_to_data() -> void:
	if data == null:
		data = Options.new()
	
	data.resolution = RESOLUTION_OPTION[$Video/Resolution_Dropdown.selected]
	data.screen_options = $Video/ScreenMode_Dropdown.get_selected_id()
	data.VSync = $Video/VSync_Button.button_pressed
	data.bgm_volume = $Music/HSlider_BGM.value
	data.sfx_volume = $Music/HSlider_SFX.value

func data_to_gui() -> void:
	if data == null:
		data = Options.new()
	
	for index in range(RESOLUTION_OPTION.size()):
		if data.resolution == RESOLUTION_OPTION[index]:
			$Video/Resolution_Dropdown.selected = index
	$Video/ScreenMode_Dropdown.select($Video/ScreenMode_Dropdown.get_item_index(data.screen_options))
	$Video/VSync_Button.button_pressed = data.VSync
	$Music/HSlider_BGM.value = data.bgm_volume
	$Music/HSlider_SFX.value = data.sfx_volume

func apply_data() -> void:
	DisplayServer.window_set_size(data.resolution)
	DisplayServer.window_set_mode(data.screen_options)
	if data.VSync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), data.bgm_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), data.sfx_volume)

func _on_apply_pressed() -> void:
	gui_to_data()
	data.save()
	apply_data()

func _change_option_visibility(toggled_on : bool) -> void:
	%Main.visible = not toggled_on
	self.visible = toggled_on

func _on_any_button_pressed() -> void:
	SoundManager.play_sfx("select")
