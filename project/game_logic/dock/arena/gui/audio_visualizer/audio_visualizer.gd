extends Node2D

const RIGHT_END : int = 1920
const LEFT_END : int = 0
const FREQ_MAX := 11050.0
@export var bar_value : int = 32
@export var slack_ratio : float = 0.2
@export var bar_min_height := 20.0
@export var bar_min_db := -70.0
@export var bar_max_height := 600.0
@export var bar_max_db := -30.0
@export var color_left : Color = Color.DEEP_SKY_BLUE
@export var color_right : Color = Color.DARK_VIOLET
@export var decay_speed := 80.0

var prev_height : Array[float] = []

func _ready() -> void:
	set_process(false)
	await _make_bars()
	prev_height.resize(bar_value)
	prev_height.fill(bar_min_height)
	if self.visible:
		set_process(true)

func _process(delta) -> void:
	_decay_visuals(delta)

func _make_bars() -> void:
	var bar_size : float = float(RIGHT_END - LEFT_END) / (float(bar_value) + float(bar_value - 1) * slack_ratio)
	var slack_size : float = bar_size * slack_ratio
	
	for child in $Bars.get_children():
		child.queue_free()
	
	for i in range(bar_value):
		var bar = ColorRect.new()
		
		bar.size = Vector2(bar_size, bar_min_height)
		bar.position = Vector2(i * (bar_size + slack_size), 0)
		bar.scale = Vector2(1, -1)
		$Bars.add_child(bar)

func update_visuals() -> void:
	var spectrum := AudioServer.get_bus_effect_instance(AudioServer.get_bus_index("BGM"), 2) as AudioEffectSpectrumAnalyzerInstance
	var prev_hz = 0
	
	var bars = $Bars.get_children()
	#var tween := get_tree().create_tween()
	for i in range(bar_value):
		var hz = (i+1)*FREQ_MAX / bar_value
		var force : Vector2 = spectrum.get_magnitude_for_frequency_range(prev_hz, hz)
		var magnitude : float = linear_to_db(force.length())
		var energy := 0.0
		if force != Vector2.ZERO:
			energy = clamp((magnitude - bar_min_db) / (bar_max_db - bar_min_db), 0.0, 1.0)
		prev_hz = hz
		var height = energy * bar_max_height + (1.0-energy) * bar_min_height
		prev_height[i] = height
		var tween := get_tree().create_tween()
		tween.tween_property(bars[i], "size:y", height, 0.05).set_trans(Tween.TRANS_SINE)

func _decay_visuals(delta) -> void:
	var bars = $Bars.get_children()
	
	for i in range(bar_value):
		prev_height[i] = clamp(prev_height[i] - delta * decay_speed, bar_min_height, bar_max_height)
		var tween := get_tree().create_tween()
		tween.tween_property(bars[i], "size:y", prev_height[i], 0.05).set_trans(Tween.TRANS_SINE)
