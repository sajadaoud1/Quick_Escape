extends CanvasLayer

@onready var menu_options: Panel = $MenuOptions
@onready var timer_label: Label = $TimerLabel
@onready var level_timer: Timer = $LevelTimer
@onready var hearts_container: HBoxContainer = $HeartsContainer2
@onready var coin_counter = $CoinCounter # تأكد من إضافة المشهد في tscn بنفس الاسم

func _ready() -> void:
	get_tree().paused = false
	menu_options.visible = false
	level_timer.start()
	
	# حساب إجمالي العملات في المرحلة عند البدء (يجب أن تكون العملات في مجموعة اسمها coins)
	var total = get_tree().get_nodes_in_group("coins").size()

func _process(_delta):
	timer_label.text = "Time: " + str(ceil(level_timer.time_left))

func _on_player_health_changed(current_health: int) -> void:
	# أرسلنا الرقم 3 كحد أقصى للصحة لحل خطأ الـ Expected 2 arguments
	hearts_container.update_hearts(current_health, 3) 

# --- دوال الأزرار والتايمر المتبقية ---
func _on_menu_icon_pressed() -> void:
	menu_options.visible = !menu_options.visible
	get_tree().paused = menu_options.visible

func _on_levels_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func _on_exit_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()

func _on_menu_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_level_timer_timeout() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func _on_retry_btn_pressed() -> void:
	get_tree().paused = false
	if GameData.current_level_path != "":
		get_tree().change_scene_to_file(GameData.current_level_path)
	else:
		print("ERROR: No level path saved")

func add_time(amount: int):
	var remaining = level_timer.time_left
	level_timer.stop()
	level_timer.wait_time = remaining + amount
	level_timer.start()
	
func refresh_ui():
	coin_counter.update_display()
