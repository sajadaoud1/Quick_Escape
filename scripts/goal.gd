extends Node


func level_completed():
	var current_level_number := get_level_number()
	
	if GameData.unlocked_levels < current_level_number + 1:
		GameData.unlocked_levels = current_level_number + 1

	save_progress()
	get_tree().change_scene_to_file("res://scenes/level_complete_screen.tscn")
	
func get_level_number() -> int:
	var file := GameData.current_level_path.get_file()
	# level_2.tscn -> 2
	return int(file.replace("level_", "").replace(".tscn", ""))
	
func save_progress():
	var file := FileAccess.open("user://save.dat", FileAccess.WRITE)
	file.store_32(GameData.unlocked_levels)
	file.close()
