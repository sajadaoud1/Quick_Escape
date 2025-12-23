extends Area2D

func _ready():
	$AnimatedSprite2D.play("idle")

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.collect_diamond()
		$AudioStreamPlayer2D.play()
		visible = false
		collision_layer = 0
		collision_mask = 0
		
		# الانتظار لحين انتهاء الصوت
		await $AudioStreamPlayer2D.finished
		queue_free()
