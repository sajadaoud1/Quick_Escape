extends HBoxContainer

# تأكد أن المسار بين القوسين هو نفس مسار مشهد القلب عندك
@onready var heart_gui_class = preload("res://scenes/heart_gui.tscn") 

func update_hearts(current_health: int):
	# حذف القلوب القديمة لكي لا تتراكم
	for child in get_children():
		child.queue_free()
	
	# إضافة عدد القلوب الجديد بناءً على صحة اللاعب
	for i in range(current_health):
		var heart = heart_gui_class.instantiate()
		add_child(heart)
