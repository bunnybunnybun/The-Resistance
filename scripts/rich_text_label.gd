extends RichTextLabel

@onready var label: = $"."
@onready var label2: = $"../../Label2"
@onready var current_dialog = 1
@onready var dialogs = {
	1: "Ah, I can see you don't even know where to begin with using this machine... Let me teach you the basics.\n\nThe text that's currently on your screen is called the 'prompt', the first word is your username, the second is the name of your computer. The part right after the computer name shows what directory/folder you are currently in. ",
	2: "Speaking of directories, let's see what's [i]inside[/i] the current directory. You can do this by using the command 'ls'. It will print the names of all folders and files within the current directory.         \n\nTry that now.         \n\nThen, you can navigate into one of the folders that is inside of your current directory by doing 'cd <folder name>'. For example, to move into the Downloads folder, type 'cd Downloads'.        \n\nThe file-system can be thought of as a hierarchy, or a tree. To go back to up to the parent directory (which is higher in the hierarchy, or a branch closer to the trunk of the tree), you can do 'cd ..'.",
	3: "The file-system starts at the \"/\" directory, often called the root directory (in our hierarchy example, this would be the very top of the hierarchy).\nWhen we moved into the Downloads folder, we did that by entering the [i]relative[/i] path to it, but we could also use the full path, like this: 'cd /home/user/Downloads'. A full path always starts with a '/' symbol, while relative paths do not."
}
func _ready() -> void:
	label.text = dialogs[current_dialog]
	label2.visible = false
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
		label.accept_event()
		#print("Space pressed. Current dialog is " + current_dialog)
		label.visible_ratio = 0.0
		label2.visible = false
		current_dialog += 1
		if dialogs.has(current_dialog):
			label.text = dialogs[current_dialog]
			var tween_speed: float = text.length()*Global.dialog_speed
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_LINEAR)
			tween.tween_property(label, "visible_ratio", 1.0, tween_speed)
			tween.finished.connect(on_tween_finish)
		else:
			print("Oh no you've reached the end of the dialog!!")
