extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@export var open_distance: float = 50.0 
@export var collision_enabled_when_closed: bool = true  # تفعيل الاصطدام لما يسكر

@onready var sprite = $Sprite2D  # أو اسم الـ Sprite تبعك
@onready var collision = $CollisionShape2D

var player: Node2D
var is_closed: bool = true

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
	if collision:
		collision.disabled = false
		
func _process(_delta):
	if player and is_closed:
		# حساب المسافة بين اللاعب والباب
		var distance = global_position.distance_to(player.global_position)
		
		# إذا اللاعب بعد عن الباب
		if distance < open_distance:
			open_door()

func open_door():
	is_closed = false
	anim.play()

	# تفعيل الاصطدام
	if collision and collision_enabled_when_closed:
		collision.disabled = true
