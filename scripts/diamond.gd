extends Area2D

func _ready():
	$AnimatedSprite2D.play("idle")

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.collect_diamond()

		visible = false
		collision_layer = 0
		collision_mask = 0

		var door = get_tree().get_first_node_in_group("final_door")
		if door:
			print("diamond taken")
			door.open_door()
		else:
			print("ERROR: final_door not found")

		queue_free()
