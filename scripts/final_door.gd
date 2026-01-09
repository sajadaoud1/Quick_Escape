extends Area2D

var player = Node2D
var is_closed = true
var is_opend = false
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var opendoor_sound: AudioStreamPlayer2D = $OpendoorSound
@onready var closedoor_sound: AudioStreamPlayer2D = $ClosedoorSound
@export var open_distance: float = 50.0 

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
	if collision:
		collision.disabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func try_open_the_door():
	var distance = global_position.distance_to(player.global_position)

	if distance < open_distance and player.diamonds >= 1:
		open_door()
	else:
		closedoor_sound.play()



func open_door():
	opendoor_sound.play()
	anim.play("open")

	collision.disabled = true
	is_opend = true

func _on_body_entered(body: Node2D) -> void:
	if is_opend:
		if has_node("/root/Goal"):
			Goal.level_completed()
	
	if body.is_in_group("player"):
		try_open_the_door()
