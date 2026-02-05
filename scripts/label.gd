extends Label

@onready var label: = $"."
@onready var label2: = $"../Label2"
@onready var disclaimer = $"../Label3"
@onready var current_dialog = "1"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(6.0).timeout
	disclaimer.visible = false
	label.visible = true
	print("Ready!")
	var tween_speed: float = text.length()*Global.dialog_speed
	visible_ratio = 0.0
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(label, "visible_ratio", 1.0, tween_speed)
	tween.finished.connect(on_tween_finish)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_tween_finish():
	label2.visible = true
	
func _input(event):
	if Input.is_action_just_pressed("continue_in_dialog") and label2.visible == true:
		print("Space pressed. Current dialog is " + current_dialog)
		label.visible_ratio = 0.0
		label2.visible = false
		if current_dialog == "1":
			current_dialog = "2"
			label.text = "You want to join the resistance, yeah? Well you're gonna need to learn how to hack, so we can take down their systems.\nModern computers have a backdoor in them, that the government uses to spy on us civilians, so you'll have to settle for this very old computer. You may notice it uses a CRT display, and doesn't have a GUI...       \nI'm sure it's not what you're used to, but it will work for our purposes."
			var tween_speed: float = text.length()*Global.dialog_speed
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_LINEAR)
			tween.tween_property(label, "visible_ratio", 1.0, tween_speed)
			tween.finished.connect(on_tween_finish)
		else:
			get_tree().change_scene_to_file("res://scenes/LearningTheBasics.tscn")
