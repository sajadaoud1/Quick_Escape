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
	sprite.flip_h = direction == -1


func _on_kill_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not attacking:
		kill_player(body)
		
func kill_player(player):
	attacking = true
	velocity = Vector2.ZERO
	
	# 1. تشغيل أنيميشن القتل
	sprite.play("kill")
	
	# 2. خصم حياة اللاعب (سينقص القلب الأخير هنا)
	if player.has_method("take_damage"):
		# سنقوم بتعديل بسيط هنا: نخصم الصحة لكن نمنع الموت الفوري
		player.current_health -= 1
		player.current_health = clampi(player.current_health, 0, player.max_health)
		player.health_changed.emit(player.current_health)
	
	# 3. انتظر حتى ينتهي أنيميشن العدو وهو يضرب
	await sprite.animation_finished
	
	# 4. الآن نتحقق: إذا كانت صحة اللاعب 0، نقتله فعلياً
	if player.current_health <= 0:
		player.die()
	else:
		# إذا لم يمت، يكمل العدو الركض
		attacking = false 
		sprite.play("run")
