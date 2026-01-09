extends ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_up(max_health: int):
	max_value = max_health
	value = max_health
	
func update_health_bar (current_health:int):
	value = current_health	
