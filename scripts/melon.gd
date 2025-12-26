extends Area2D

@export var time_bonus := 2

@onready var sfx := $AudioStreamPlayer2D

var picked := false

func _on_body_entered(body):
	if picked:
		return

	if body.is_in_group("player"):
		picked = true
		body.add_time(time_bonus)

		# Disable collision immediately
		collision_layer = 0
		collision_mask = 0
		visible = false

		# Play sound, then delete
		sfx.play()
		await sfx.finished
		queue_free()
