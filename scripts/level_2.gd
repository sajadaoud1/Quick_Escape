extends Node2D

var time_left := 60

@onready var time_label := $CanvasLayer/TimeLabel

func _ready() -> void:
	# Save current level path
	GameData.current_level_path = scene_file_path

	# COUNT COINS IN THIS LEVEL
	var coins = get_tree().get_nodes_in_group("coins")
	GameData.level_total_coins = coins.size()
	GameData.level_coins_collected = 0

	# REFRESH UI
	var ui = get_tree().get_first_node_in_group("ui")
	if ui:
		ui.refresh_ui()

func add_time(amount: int):
	time_left += amount
	time_label.text = str(time_left)
