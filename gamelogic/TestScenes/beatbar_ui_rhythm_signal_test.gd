extends Node

func _process(_delta):
	$Control/beat_count.text = str($rhythm.beat_count)
	$Control/time.text = str($rhythm.get_time())
