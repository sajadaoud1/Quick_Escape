extends CharacterBody2D

@export var speed := 150
@export var attack_range: float = 40.0
@export var attack_damage: int = 1
@export var diamond_scene: PackedScene
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@export var max_health = 50
@onready var current_health :int  = max_health
@onready var attack_hitbox: Area2D = $AttackHitBox
@export var attack_duration := 0.2
signal health_changed(current_health) 
var is_attacking := false
signal coin_collected(current_amount) 
var coins_collected := 0 
var has_key := false
var has_diamond := false
var last_dir := Vector2.DOWN
var diamonds := 0
var is_invincible := false  

func _ready():
	current_health = max_health
	await get_tree().process_frame
	health_changed.emit(current_health)
	attack_hitbox.monitoring = false

func _process(_delta):
	if Input.is_action_just_pressed("attack"):
		attack()

func take_damage(amount: int):
	if is_invincible:
		return
	current_health -= amount
	current_health = clampi(current_health, 0, max_health)
	
	health_changed.emit(current_health)
	if current_health <= 0:
		die()
	else:
		$KillSound.play()
		start_invincibility()

func start_invincibility():
	is_invincible = true
	anim.modulate.a = 0.5 
	
	await get_tree().create_timer(1.0).timeout 
	
	is_invincible = false
	anim.modulate.a = 1.0 
	
func _physics_process(delta):
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	var dir := Vector2.ZERO
	
	if Input.is_action_pressed("right"):
		dir = Vector2.RIGHT
	elif Input.is_action_pressed("left"):
		dir = Vector2.LEFT
	elif Input.is_action_pressed("down"):
		dir = Vector2.DOWN
	elif Input.is_action_pressed("up"):
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
			
func play_attack_animation():
	if abs(last_dir.x) > abs(last_dir.y):
		anim.play("attacking_side")
		anim.flip_h = last_dir.x < 0
	else:
		if last_dir.y > 0:
			anim.play("attacking_front")
		else:
			anim.play("attacking_back")
	$AxeSound.play()

func pick_key():
	has_key = true
	$KeyInHand.visible = true

func remove_key():
	has_key = false
	$KeyInHand.visible = false
	
func collect_diamond():
	diamonds += 1

func collect_coin():
	GameData.level_coins_collected += 1
 
	# refresh UI safely
	var ui = get_tree().get_first_node_in_group("ui")
	if ui:
		ui.refresh_ui()

func die():
	# سنقوم بتعطيل حركة اللاعب لكي لا يتحرك وهو يموت
	set_physics_process(false)
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	
func add_time(amount: int):
	var ui = get_parent().get_node_or_null("UI")
	if ui and ui.has_method("add_time"):
		ui.add_time(amount)

func attack():
	if is_attacking:
		return # prevent attack spamming
	
	is_attacking = true

	# play animation
	play_attack_animation()

	# enable hitbox
	attack_hitbox.monitoring = true

	# wait for attack duration
	await get_tree().create_timer(attack_duration).timeout

	attack_hitbox.monitoring = false
	is_attacking = false

func _on_attack_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.die()
