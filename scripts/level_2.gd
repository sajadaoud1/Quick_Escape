extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameData.current_level_path = scene_file_path
