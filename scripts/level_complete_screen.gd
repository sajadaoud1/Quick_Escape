extends Control

@onready var star1: TextureRect = $star1
@onready var star2: TextureRect = $star2
@onready var star3: TextureRect = $star3

func _ready() -> void:
	update_stars()

func show_stars():
	# hide all first
	star1.visible = false
	star2.visible = false
	star3.visible = false

	var level_number := get_level_number()
	var stars: int = GameData.level_stars.get(level_number, 0)


	if stars >= 1:
		star1.visible = true
	if stars >= 2:
		star2.visible = true
	if stars >= 3:
		star3.visible = true

func get_level_number() -> int:
	var file := GameData.current_level_path.get_file()
	return int(file.replace("level_", "").replace(".tscn", ""))

func _on_retry_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(GameData.current_level_path)

func _on_menu_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_next_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func update_stars():
	var stars := GameData.last_level_stars

	star1.visible = stars >= 1
	star2.visible = stars >= 2
	star3.visible = stars >= 3
