extends Node2D

@export var health: int = 3
@export var broken_texture: Texture2D

@onready var sprite = $Sprite2D
@onready var static_body = $StaticBody2D

var current_health: int

func _ready():
	current_health = health
	add_to_group("breakable")

func take_damage(amount: int = 1):
	current_health -= amount
	
	flash()
	
	if has_node("AudioStreamPlayer2D"):
		$AudioStreamPlayer2D.play()
	
	if current_health <= 0:
		break_box()

func flash():
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.5, 0.1)
	tween.tween_property(sprite, "modulate:a", 1.0, 0.1)

func break_box():
	if broken_texture:
		sprite.texture = broken_texture
	
	if static_body:
		static_body.queue_free()
	
	remove_from_group("breakable")
