extends Control

var unlocked_levels := 1   # later loaded from save

func _ready():
	var buttons = $GridContainer.get_children()
	for i in buttons.size():
		var btn = buttons[i]
		btn.level_number = i + 1
		btn.setup(i < unlocked_levels)
		btn.pressed.connect(_on_level_pressed.bind(i + 1))

func _on_level_pressed(level_number):
	get_tree().change_scene_to_file(
		"res://scenes/levels/level_%d.tscn" % level_number
	)


func _on_back_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
