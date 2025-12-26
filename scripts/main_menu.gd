extends Control

@onready var main_btn: VBoxContainer = $MainBtn
@onready var settings: Panel = $Settings


func _ready() -> void:
	main_btn.visible = true
	settings.visible = false

func _on_start_game_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")


func _on_settings_btn_pressed() -> void:
	main_btn.visible = false
	settings.visible = true


func _on_help_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/help_screen.tscn")


func _on_back_settings_btn_pressed() -> void:
	_ready()


func _on_exit_btn_pressed() -> void:
	get_tree().quit()
