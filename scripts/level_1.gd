extends Node2D

@onready var menu_options: Panel = $UI/MenuOptions
@onready var timer_label: Label = $UI/TimerLabel
@onready var level_timer: Timer = $LevelTimer

var level_number = 1

func _ready() -> void:
	get_tree().paused = false
	GameData.current_level_path = scene_file_path


func _on_level_completed():
	GameData.unlock_next_level(level_number)
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")
