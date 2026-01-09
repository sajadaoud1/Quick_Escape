extends CharacterBody2D

@export var speed := 60
@export var damage := 10

var direction := 1
var attacking := false

@onready var sprite := $AnimatedSprite2D
@onready var ray_right := $RayRight
@onready var ray_left := $RayLeft

func _physics_process(delta):
	if attacking:
		return

	velocity.x = direction * speed
	move_and_slide()

	if sprite.animation != "run":
		sprite.play("run")

	if direction == 1 and ray_right.is_colliding():
		turn()
	elif direction == -1 and ray_left.is_colliding():
		turn()

func turn():
	direction *= -1
	sprite.flip_h = direction == -1

	if direction == -1:
		$KillArea.position.x = -abs($KillArea.position.x)
	else:
		$KillArea.position.x = abs($KillArea.position.x)

func _on_kill_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not attacking:
		kill_player(body)

func kill_player(player):
	attacking = true
	velocity = Vector2.ZERO

	if direction == 1:
		sprite.play("kill")
	else:
		sprite.play("kill_left")

	if player.has_method("take_damage"):
		player.take_damage(damage)

	await sprite.animation_finished
	attacking = false
	sprite.play("run")

func _on_hit_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_attack"):
		die()

func die():
	queue_free()
