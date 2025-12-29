extends HBoxContainer

@onready var count_label = $Label
@onready var coin_display = $CoinDisplay/AnimatedSprite2D

func _ready():
	if coin_display:
		coin_display.play("default")
	update_display()

func update_display():
	count_label.text = str(GameData.level_coins_collected) + " / " + str(GameData.level_total_coins)
