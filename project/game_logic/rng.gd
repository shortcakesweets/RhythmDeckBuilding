extends Node

var rng = RandomNumberGenerator.new()
var seed : int = 0

func set_random_seed():
	rng.randomize()
	seed = rng.get_seed()

func set_custom_seed(custom_seed : int):
	rng.set_seed(custom_seed)

func weighted_rng_dict(weight_dict : Dictionary) -> String:
	var weight_sum := 0
	for key in weight_dict:
		weight_sum += weight_dict[key]
	var value = rng.randi_range(0, weight_sum - 1)
	var threshold := 0
	for key in weight_dict:
		threshold += weight_dict[key]
		if value < threshold:
			return key
	return ""

func weighted_rng_array(weight_array : Array) -> int:
	var weight_sum := 0
	for weight in weight_array:
		weight_sum += weight
	var r := rng.randf_range(0, weight_sum)
	var prev := 0
	for i in range(weight_array.size()):
		if r < prev + weight_array[i]:
			return i
		prev += weight_array[i]
	return 0
