extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var open_treasure_audio: AudioStreamPlayer2D = $OpenTreasureAudio
@onready var locked_audio: AudioStreamPlayer2D = $LockedAudio
@export var min_offset_x: float = 15
@export var max_offset_x: float = 16
@export var diamond_scene: PackedScene

var is_open := false

func _on_body_entered(body: Node2D) -> void:
	if is_open:
		return

	if body.is_in_group("player") and body.has_key:
		body.remove_key()
		open_treasure_audio.play()
		open()
	else:
		locked_audio.play()

func open():
	is_open = true
	anim.play("open")
	await get_tree().create_timer(1).timeout 
	spawn_diamond()

func spawn_diamond():
	if diamond_scene == null:
		return

	var diamond = diamond_scene.instantiate()
	var offset_x = randf_range(min_offset_x, max_offset_x)

	diamond.global_position = global_position + Vector2(offset_x, 0)
	get_parent().add_child(diamond)
