extends Node2D

var time_left := 60

@onready var time_label := $CanvasLayer/TimeLabel


func _ready() -> void:
	GameData.current_level_path = scene_file_path

func add_time(amount: int):
	time_left += amount
	time_label.text = str(time_left)
