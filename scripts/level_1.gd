extends Node2D

@onready var menu_options: Panel = $UI/MenuOptions
@onready var timer_label: Label = $UI/TimerLabel
@onready var level_timer: Timer = $LevelTimer


var time_left := 60

@onready var time_label := $CanvasLayer/TimeLabel

var level_number = 1

func _ready() -> void:
	get_tree().paused = false
	GameData.current_level_path = scene_file_path

	var coins = get_tree().get_nodes_in_group("coins")
	GameData.level_total_coins = coins.size()
	GameData.level_coins_collected = 0

	var ui = get_tree().get_first_node_in_group("ui")
	if ui:
		ui.refresh_ui()

func _on_level_completed():
	GameData.unlock_next_level(level_number)
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")
	
func add_time(amount: int):
	time_left += amount
	time_label.text = str(time_left)
