extends Control

func _ready():
	hide()
	$AnimationPlayer.play("RESET")

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
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()


	
func _process(delta):
	escape()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if get_tree().paused == false:
		hide()
