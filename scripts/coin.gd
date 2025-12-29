extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("collect_coin"):
		body.collect_coin()

	$AudioStreamPlayer2D.play()
	visible = false
	collision_layer = 0
	collision_mask = 0

	await $AudioStreamPlayer2D.finished
	queue_free()
