extends Resource
class_name Options

const PATH : String = "user://options.tres"
enum {WINDOWED = 0, FULLSCREEN = 3}

@export var resolution : Vector2 = Vector2(1920, 1080)
@export var screen_options : int = FULLSCREEN
@export var VSync : bool = false
@export var bgm_volume : float = 0.0
@export var sfx_volume : float = 0.0
@export var vid_offset : float = 0.0
@export var music_offset : float = 0.0

func save() -> void:
	#print("Saving data")
	ResourceSaver.save(self, PATH)

func load() -> Resource:
	#print("Loading data")
	if not ResourceLoader.exists(PATH):
		#print("No file exists. make new resource data.")
		save()
	return load(PATH)
