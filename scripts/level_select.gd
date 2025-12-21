extends Control

@onready var grid := $GridContainer

func _ready():
	update_level_buttons()
	connect_level_buttons()

func update_level_buttons():
	for i in range(grid.get_child_count()):
		var btn: Button = grid.get_child(i)
		if btn == null:
			continue
		var level_number = i + 1
		btn.text = str(level_number)

		var lock_icon = btn.get_node("LockIcon")
		
		if level_number <= GameData.unlocked_levels:
			btn.disabled = false
			lock_icon.visible = false

		else:
			btn.disabled = true
			lock_icon.visible = true

func connect_level_buttons():
	for i in range(grid.get_child_count()):
		var btn: Button = grid.get_child(i)
		var level_number := i + 1
		btn.pressed.connect(_on_level_pressed.bind(level_number))

func _on_back_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_level_pressed(level_number: int) -> void:
	if level_number <= GameData.unlocked_levels:
		var scene_path := "res://scenes/levels/level_%d.tscn" % level_number
		get_tree().change_scene_to_file(scene_path)
