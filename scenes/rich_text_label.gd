extends RichTextLabel

@onready var label: = $"."
@onready var label2: = $"../Label2"
@onready var current_dialog = "1"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Ready!")
	label2.visible = false
	var tween_speed: float = text.length()*0.02
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
		label.accept_event()
		print("Space pressed. Current dialog is " + current_dialog)
		label.visible_ratio = 0.0
		label2.visible = false
		if current_dialog == "1":
			current_dialog = "2"
			label.text = "Speaking of directories, let's see what's [i]inside[/i] the current directory. You can do this by using the command 'ls'. It will print the names of all folders and files within the current directory."
			var tween_speed: float = text.length()*0.02
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_LINEAR)
			tween.tween_property(label, "visible_ratio", 1.0, tween_speed)
			tween.finished.connect(on_tween_finish)
		else:
			get_tree().change_scene_to_file("res://scenes/LearningTheBasics.tscn")
