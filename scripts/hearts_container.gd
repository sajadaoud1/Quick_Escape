extends HBoxContainer

@onready var heart_gui_class = preload("res://scenes/heart_gui.tscn")

# نفرض أن أقصى عدد قلوب هو 5 مثلاً، أو استقبله كمتغير
func update_hearts(current_health: int, max_health: int):
	# إذا كانت القلوب غير موجودة أصلاً (أول مرة)، ننشئها بعدد الـ max_health
	if get_child_count() != max_health:
		for child in get_children():
			child.queue_free()
		
		for i in range(max_health):
			var heart = heart_gui_class.instantiate()
			add_child(heart)

	# الآن نمر على القلوب الموجودة ونحدد من ممتلئ ومن فارغ
	var hearts = get_children()
	for i in range(max_health):
		if i < current_health:
			hearts[i].update(true)  # قلب ممتلئ
		else:
			hearts[i].update(false) # قلب فارغ
