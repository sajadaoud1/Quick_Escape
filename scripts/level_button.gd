extends Button

@export var level_number: int = 1
@onready var lock_icon = $TextureRect
@onready var label = $Label

func setup(unlocked: bool):
	label.text = str(level_number)
	lock_icon.visible = not unlocked
	disabled = not unlocked
