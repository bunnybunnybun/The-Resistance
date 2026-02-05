extends Control

@onready var dialogspeedslider: Slider = get_node("MainColorRect/Settings/DialogSpeedSlider")

func _ready():
	dialogspeedslider.value = Global.dialog_speed_slider_value
	$AnimationPlayer.play("RESET")
	$MainColorRect/Main.show()
	$MainColorRect/Settings.hide()

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	
func pause():
	get_tree().paused = true
	show()
	$AnimationPlayer.play("blur")
	
func escape():
	if Input.is_action_just_pressed("escape") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused:
		resume()

func _on_resume_pressed() -> void:
	resume()

func _on_settings_pressed() -> void:
	$MainColorRect/Main.hide()
	$MainColorRect/Settings.show()
	
func _on_quit_pressed() -> void:
	get_tree().quit()

func _process(delta):
	escape()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if get_tree().paused == false:
		hide()
		$MainColorRect/Main.show()
		$MainColorRect/Settings.hide()

func _on_dialog_speed_slider_value_changed(value: float):
	if value == 4:
		Global.dialog_speed = 0.01
		Global.dialog_speed_slider_value = 4
	elif value == 3:
		Global.dialog_speed = 0.025
		Global.dialog_speed_slider_value = 3
	elif value == 2:
		Global.dialog_speed = 0.04
		Global.dialog_speed_slider_value = 2
	elif value == 1:
		Global.dialog_speed = 0.055
		Global.dialog_speed_slider_value = 1
