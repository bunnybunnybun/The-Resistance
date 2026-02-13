extends TextureButton
@onready var button = $"."
@onready var answer_box = $"../answer_box"

func _ready():
	button.visible = false
	answer_box.visible = false
	


func _on_pressed():
	if answer_box.visible == false:
		answer_box.visible = true
	else:
		answer_box.visible = false
