extends Node

var unlocked_levels: int = 1
var current_level_path: String = ""

func unlock_next_level(currunt_level:int):
	if currunt_level >= unlocked_levels:
		unlocked_levels += 1
	
func _ready():
	load_progress()

func load_progress():
	if not FileAccess.file_exists("user://save.dat"):
		return
	
	var file := FileAccess.open("user://save.dat", FileAccess.READ)
	unlocked_levels = file.get_32()
	file.close()
