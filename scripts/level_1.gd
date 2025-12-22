extends Node2D

@onready var menu_options: Panel = $CanvasLayer/MenuOptions

var level_number = 1

func _ready() -> void:
	menu_options.visible = false

func _on_level_completed():
	GameData.unlock_next_level(level_number)
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func _on_menu_icon_pressed() -> void:
	menu_options.visible = !menu_options.visible
	get_tree().paused = menu_options.visible

func _on_levels_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func _on_exit_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()

func _on_menu_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
