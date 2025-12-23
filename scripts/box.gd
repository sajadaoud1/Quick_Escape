extends Area2D

@export var diamond_scene: PackedScene
@export var delay_time: float = 0.5
@export var min_offset_x: float = 15
@export var max_offset_x: float = 16

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_key:
		$AudioStreamPlayer2D.play()
		body.remove_key()

		hide()  # أخفي الصندوق فورًا
		await get_tree().create_timer(delay_time).timeout  # انتظر delay_time ثانية
		spawn_diamond()
		queue_free()  # حذف الصندوق بعد ظهور الماسة
		
func spawn_diamond():
	var diamond = diamond_scene.instantiate()
	
	# حساب موقع الماسة الجديد بعيدا عن الصندوق على اليمين
	var offset_x = randf_range(min_offset_x, max_offset_x)
	var new_position = global_position + Vector2(offset_x, 0)
	
	diamond.global_position = new_position
	get_parent().add_child(diamond)
