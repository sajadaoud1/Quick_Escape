extends Area2D

@export var damage := 1
@export var up_time := 1.0
@export var down_time := 1.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

var active := false

func _ready():
	body_entered.connect(_on_body_entered)
	start_cycle()

func start_cycle():
	while true:
		# Trap UP (dangerous)
		active = true
		collision_polygon_2d.disabled = false
		anim.play("default")
		await get_tree().create_timer(up_time).timeout

		# Trap DOWN (safe)
		active = false
		collision_polygon_2d.disabled = true
		anim.frame = 0
		anim.stop()
		await get_tree().create_timer(down_time).timeout

func _on_body_entered(body):
	if not active:
		return

	if body.has_method("take_damage"):
		body.take_damage(damage)
