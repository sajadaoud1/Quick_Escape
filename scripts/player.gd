extends CharacterBody2D

@export var speed := 220
@export var attack_range: float = 60.0
@export var attack_damage: int = 1

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var last_dir := Vector2.DOWN

func _physics_process(delta):
	var dir := Vector2.ZERO
	
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
	if event.is_action_pressed("ui_accept"):
		attack()

func attack():
	print("Attack pressed!")
	
	var breakables = get_tree().get_nodes_in_group("breakable")
	print("Found ", breakables.size(), " breakable objects")
	
	for box in breakables:
		var distance = global_position.distance_to(box.global_position)
		print("Distance to box: ", distance)
		
		if distance <= attack_range:
			print("Box in range! Breaking...")
			if box.has_method("take_damage"):
				box.take_damage(attack_damage)
			break
