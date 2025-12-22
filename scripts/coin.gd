extends Area2D



func _on_body_entered(body: Node2D) -> void:
	
	$AudioStreamPlayer2D.play()
	visible = false
	collision_layer = 0
	collision_mask = 0
	
	# الانتظار لحين انتهاء الصوت
	await $AudioStreamPlayer2D.finished
	
	

	
	queue_free()
