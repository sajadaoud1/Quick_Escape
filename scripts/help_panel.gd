extends Control

@onready var panel: Panel = $Panel
@onready var panel_2: Panel = $Panel2
@onready var panel_3: Panel = $Panel3
@onready var panel_4: Panel = $Panel4

func _ready() -> void:
	panel.visible = true
	panel_2.visible = false
	panel_3.visible = false
	panel_4.visible = false
	get_tree().paused = true

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_right_btn_1_pressed() -> void:
	panel.visible = false
	panel_2.visible = true
	panel_3.visible = false
	panel_4.visible = false

func _on_back_btn_1_pressed() -> void:
	panel.visible = true
	panel_2.visible = false
	panel_3.visible = false
	panel_4.visible = false

func _on_right_btn_2_pressed() -> void:
	panel.visible = false
	panel_2.visible = false
	panel_3.visible = true
	panel_4.visible = false

func _on_back_btn_2_pressed() -> void:
	panel.visible = false
	panel_2.visible = true
	panel_3.visible = false
	panel_4.visible = false

func _on_right_btn_3_pressed() -> void:
	panel.visible = false
	panel_2.visible = false
	panel_3.visible = false
	panel_4.visible = true


func _on_back_btn_3_pressed() -> void:
	panel.visible = false
	panel_2.visible = false
	panel_3.visible = true
	panel_4.visible = false
