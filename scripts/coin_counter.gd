extends HBoxContainer

# تعديل المسار للوصول إلى AnimatedSprite2D الموجود داخل CoinDisplay
@onready var count_label = $Label
@onready var coin_display = $CoinDisplay/AnimatedSprite2D 

var current_coins = 0
var total_level_coins = 0

func _ready():
	# الآن يمكنك استدعاء play لأننا حددنا العقدة الصحيحة
	if coin_display:
		coin_display.play("default")
	update_display()

func update_coins(new_current_coins: int):
	current_coins = new_current_coins
	update_display()

func set_total_coins(total: int):
	total_level_coins = total
	update_display()

func update_display():
	count_label.text = str(current_coins) + " / " + str(total_level_coins)


func _on_player_coin_collected(current_amount: Variant) -> void:
	pass # Replace with function body.
