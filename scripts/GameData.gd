extends Node

var unlocked_levels: int = 1
var current_level_path: String = ""

var level_total_coins: int = 0
var level_coins_collected: int = 0

var last_level_stars: int = 0 

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


func calculate_stars() -> int:
	if level_total_coins <= 0:
		return 0

	var ratio := float(level_coins_collected) / float(level_total_coins)

	if ratio >= 1.0:
		return 3
	elif ratio >= 0.67:
		return 2
	elif ratio >= 0.34:
		return 1
	else:
		return 0
		
