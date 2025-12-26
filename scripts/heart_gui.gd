extends TextureRect
# اسحب صور القلوب هنا من الـ FileSystem إلى الكود
var heart_full = preload("res://assets/Pixel Heart full - Copy.png") 
var heart_empty = preload("res://assets/Pixel Heart Empty.png")

func update(whole: bool):
	if whole:
		texture = heart_full
	else:
		texture = heart_empty
