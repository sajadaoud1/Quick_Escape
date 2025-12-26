extends CharacterBody2D

@export var speed := 60
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
	# قلب صورة الركض العادية
	sprite.flip_h = direction == -1
	
	# تحريك منطقة القتل (المستطيل البرتقالي) لجهة اتجاه العدو
	# إذا كانت المنطقة في المنتصف، قد تحتاج لتعديل الـ Position بدلاً من الـ Scale
	if direction == -1:
		$KillArea.position.x = -abs($KillArea.position.x)
	else:
		$KillArea.position.x = abs($KillArea.position.x)


func _on_kill_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not attacking:
		kill_player(body)
		
func kill_player(player):
	attacking = true
	velocity = Vector2.ZERO
	
	# اختيار الأنيميشن بناءً على الاتجاه
	if direction == 1:
		sprite.play("kill")      # أنيميشن القتل لجهة اليمين
	else:
		sprite.play("kill_left") # تأكد أن هذا هو اسم الأنيميشن عندك لجهة اليسار
	
	if player.has_method("take_damage"):
		player.take_damage(1)
	
	await sprite.animation_finished
	
	attacking = false 
	sprite.play("run")
