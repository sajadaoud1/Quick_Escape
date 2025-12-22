extends CharacterBody2D

@export var speed := 220
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var last_dir := Vector2.DOWN
@export var attack_range: float = 30.0  # مدى الهجوم
@export var attack_damage: int = 1  # قوة الضربة

func _physics_process(delta):
	var dir := Vector2.ZERO

	# Horizontal has priority
	if Input.is_action_pressed("ui_right"):
		dir = Vector2.RIGHT
	elif Input.is_action_pressed("ui_left"):
		dir = Vector2.LEFT
	elif Input.is_action_pressed("ui_down"):
		dir = Vector2.DOWN
	elif Input.is_action_pressed("ui_up"):
		dir = Vector2.UP
	
	if dir != Vector2.ZERO:
		last_dir = dir
		velocity = dir * speed  
		play_walk_animation(dir)
	else:
		velocity = Vector2.ZERO
		play_idle_animation()

	move_and_slide()

func play_idle_animation():
	if abs(last_dir.x) > abs(last_dir.y):
		anim.play("idle_side")
		anim.flip_h = last_dir.x < 0
	else:
		if last_dir.y > 0:
			anim.play("idle_front")
		else:
			anim.play("idle_back")

func play_walk_animation(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		anim.play("walk_side")
		anim.flip_h = dir.x < 0
	else:
		if dir.y > 0:
			anim.play("walk_front")
		else:
			anim.play("walk_back")

func _input(event):
	# عند الضغط على زر المسافة (Space)
	if event.is_action_pressed("ui_accept"):  # أو أي زر تختاره
		attack()

func attack():
	# البحث عن TileMapLayer
	var tilemap = get_tree().get_first_node_in_group("breakable_tilemap")
	
	if tilemap and tilemap.has_method("damage_tile_at_position"):
		# حساب موقع الضربة (أمام اللاعب)
		var attack_pos = global_position
		
		# إذا بدك الضربة تكون في اتجاه حركة اللاعب
		# attack_pos += velocity.normalized() * attack_range
		
		# ضرب الـ tile في هذا الموقع
		tilemap.damage_tile_at_position(attack_pos, attack_damage)
