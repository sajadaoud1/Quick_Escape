extends Control


func _ready() -> void:
	pass # Replace with function body.


func _on_retry_btn_pressed() -> void:
	get_tree().paused = false
	
	if GameData.current_level_path != "":
		get_tree().change_scene_to_file(GameData.current_level_path)
	else:
		print("ERROR: No level path saved")


func _on_menu_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_next_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")
