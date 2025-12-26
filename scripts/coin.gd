extends Area2D



func _on_body_entered(body: Node2D) -> void:
	# التحقق إذا كان الجسم الذي دخل هو اللاعب ولديه دالة الجمع
	if body.has_method("collect_coin"):
		body.collect_coin() # استدعاء دالة الجمع في سكريبت اللاعب
	
	$AudioStreamPlayer2D.play()
	visible = false
	
	collision_layer = 0
	collision_mask = 0
	
	# الانتظار لحين انتهاء الصوت
	await $AudioStreamPlayer2D.finished
	
	queue_free()
