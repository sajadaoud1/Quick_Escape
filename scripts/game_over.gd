extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false

func _on_retry_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")


func _on_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
