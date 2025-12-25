extends Area2D

var collected := false

func _ready():
	$AnimatedSprite2D.play("idle")

func _on_body_entered(body):
	if collected:
		return

	if body.is_in_group("player"):
		collected = true

		# Give diamond to player
		body.collect_diamond()

		# Hide & disable collision
		visible = false
		collision_layer = 0
		collision_mask = 0

		# Play pickup sound
		$AudioStreamPlayer2D.play()

		# Wait for sound to finish
		await $AudioStreamPlayer2D.finished

		queue_free()
