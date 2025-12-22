extends StaticBody2D

# المتغيرات
@export var open_texture: Texture2D  # صورة الباب المفتوح
@export var closed_texture: Texture2D  # صورة الباب المسكر
@export var close_distance: float = 50.0  # المسافة اللي يسكر فيها الباب
@export var collision_enabled_when_closed: bool = true  # تفعيل الاصطدام لما يسكر

@onready var sprite = $Sprite2D  # أو اسم الـ Sprite تبعك
@onready var collision = $CollisionShape2D

var player: Node2D
var is_closed: bool = false

func _ready():
	# البحث عن اللاعب
	player = get_tree().get_first_node_in_group("player")
	
	# الباب مفتوح في البداية
	sprite.texture = open_texture
	if collision:
		collision.disabled = true  # الباب المفتوح ما عليه اصطدام

func _process(_delta):
	if player and not is_closed:
		# حساب المسافة بين اللاعب والباب
		var distance = global_position.distance_to(player.global_position)
		
		# إذا اللاعب بعد عن الباب
		if distance > close_distance:
			close_door()

func close_door():
	is_closed = true
	sprite.texture = closed_texture
	
	# تفعيل الاصطدام
	if collision and collision_enabled_when_closed:
		collision.disabled = false
	
	# تشغيل صوت إغلاق الباب
	if has_node("AudioStreamPlayer2D"):
		$AudioStreamPlayer2D.play()
