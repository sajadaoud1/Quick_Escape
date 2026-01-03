extends Control

func _ready() -> void:
	if not DisplayServer.is_touchscreen_available():
		visible = false

func _on_btn_left_button_up() -> void:
	Input.action_release("left")


func _on_btn_left_button_down() -> void:
	print("LEFT DOWN")
	Input.action_press("left")


func _on_btn_right_button_down() -> void:
	Input.action_press("right")


func _on_btn_right_button_up() -> void:
	Input.action_release("right")


func _on_btn_up_button_down() -> void:
	Input.action_press("up")


func _on_btn_up_button_up() -> void:
	Input.action_release("up")


func _on_btn_down_button_down() -> void:
	Input.action_press("down")


func _on_btn_down_button_up() -> void:
	Input.action_release("down")
