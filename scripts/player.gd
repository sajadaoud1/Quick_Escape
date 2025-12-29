extends CharacterBody2D

@export var speed := 150

@export var attack_range: float = 40.0
@export var attack_damage: int = 1
@export var tile_map_layer_3: TileMapLayer
@export var diamond_scene: PackedScene
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

signal health_changed(current_health) 
# إشارة لتحديث القلوب في الواجهة
signal coin_collected(current_amount) # إشارة لإرسال عدد العملات للواجهة
var coins_collected := 0 # متغير لتخزين عدد العملات التي جمعها اللاعب
@export var max_health: int = 3
var current_health: int

var has_key := false
var has_diamond := false

var last_dir := Vector2.DOWN

var diamonds := 0

var is_invincible := false # هل اللاعب في وضع الحماية؟


func _ready():
	current_health = max_health
	# ننتظر قليلاً للتأكد من أن الواجهة جاهزة قبل إرسال أول تحديث
	await get_tree().process_frame
	health_changed.emit(current_health)
	
func take_damage(amount: int):
	if is_invincible: # إذا كان اللاعب محمياً، لا نفعل شيئاً
		return
	current_health -= amount
	current_health = clampi(current_health, 0, max_health) # لضمان عدم نزول الصحة تحت الصفر
	
	health_changed.emit(current_health) # أخبر الواجهة أن الصحة تغيرت
	if current_health <= 0:
		die() # استدعاء دالة الموت الموجودة أصلاً في كودك
	else:
		start_invincibility() # تفعيل وضع الحماية مؤقتاً
func start_invincibility():
	is_invincible = true
	# جعل اللاعب يومض (شفافية 50%)
	anim.modulate.a = 0.5 
	
	# انتظر ثانية واحدة قبل العودة للحالة الطبيعية
	await get_tree().create_timer(1.0).timeout 
	
	is_invincible = false
	anim.modulate.a = 1.0 # إعادة اللاعب لشكلة الطبيعي
	
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
	check_tile()

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
	var breakables = get_tree().get_nodes_in_group("breakable")
	var closest_box = null
	var closest_distance = attack_range
	
	for box in breakables:
		var to_box = box.global_position - global_position
		var distance = to_box.length()
		
		var direction_match = false

		if abs(last_dir.x) > abs(last_dir.y):
			if last_dir.x > 0:
				direction_match = to_box.x > 0 and abs(to_box.y) < 20
			else:
				direction_match = to_box.x < 0 and abs(to_box.y) < 20
		else:
			if last_dir.y > 0:
				direction_match = to_box.y > 0 and abs(to_box.x) < 20
			else:
				direction_match = to_box.y < 0 and abs(to_box.x) < 20
		
		if direction_match and distance <= attack_range and distance < closest_distance:
			closest_box = box
			closest_distance = distance
	
	if closest_box and closest_box.has_method("take_damage"):
		closest_box.take_damage(attack_damage)


func pick_key():
	has_key = true
	$KeyInHand.visible = true


func remove_key():
	has_key = false
	$KeyInHand.visible = false
	
func collect_diamond():
	diamonds += 1
	print("Diamonds:", diamonds)

func collect_coin():
	GameData.level_coins_collected += 1
 
	# refresh UI safely
	var ui = get_tree().get_first_node_in_group("ui")
	if ui:
		ui.refresh_ui()
	
func spawn_diamond(cell: Vector2i):
	var diamond = diamond_scene.instantiate()

	var start_pos = tile_map_layer_3.to_global(
		tile_map_layer_3.map_to_local(cell)
	)

	diamond.global_position = start_pos + Vector2(0, -12)
	get_parent().add_child(diamond)

		
func animate_diamond_jump(diamond: Node2D, start_pos: Vector2, end_pos: Vector2):
	var tween = get_tree().create_tween()

	# Jump up
	tween.tween_property(
		diamond,
		"global_position",
		start_pos + Vector2(0, -32),
		0.25
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Fall to the side
	tween.tween_property(
		diamond,
		"global_position",
		end_pos,
		0.35
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)



func try_open_treasure(cell: Vector2i):
	if not has_key:
		$LockedSound.play()
		return

	remove_key()
	spawn_diamond_delayed(cell)

func get_player_cell() -> Vector2i:
	if tile_map_layer_3 == null:
		return Vector2i(-999, -999) # invalid cell

	var feet_pos = global_position + Vector2(0, 8)
	var local_pos = tile_map_layer_3.to_local(feet_pos)
	return tile_map_layer_3.local_to_map(local_pos)

func check_tile():
	if tile_map_layer_3 == null:
		return

	var cell = get_player_cell()
	var data = tile_map_layer_3.get_cell_tile_data(cell)

	if data == null:
		return

	var tile_type = data.get_custom_data("type")

	match tile_type:
		"key":
			take_key(cell)
		"treasure":
			try_open_treasure(cell)

func take_key(cell: Vector2i):
	pick_key()
	tile_map_layer_3.erase_cell(cell)

func spawn_diamond_delayed(cell: Vector2i):
	await get_tree().create_timer(1.0).timeout
	spawn_diamond(cell)

func die():
	# سنقوم بتعطيل حركة اللاعب لكي لا يتحرك وهو يموت
	set_physics_process(false)
	
	# ننتظر لمدة ثانية واحدة (أو حسب طول أنيميشن القتل عند العدو)
	# هذا سيعطي وقتاً للعدو لينهي حركة القتل "kill"
	await get_tree().create_timer(1.0).timeout
	
	# الآن نعيد تشغيل اللعبة
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	
func add_time(amount: int):
	var ui = get_parent().get_node_or_null("UI")
	if ui and ui.has_method("add_time"):
		ui.add_time(amount)
