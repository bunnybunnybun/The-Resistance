extends Control

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene2.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()

@onready var text_edit: TextEdit = $TextEdit
@onready var label: Label = $Label

func _ready():
	text_edit.gui_input.connect(_on_LineEdit_gui_input)
	
func _on_LineEdit_gui_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		text_edit.accept_event()
		
		var line_count = text_edit.get_line_count()
		var prompt = "[user@computer ~]$ "
		var command = ""
		for i in range(line_count - 1, -1, -1):
			var line = text_edit.get_line(i)
			if not line.is_empty():
				if line.begins_with(prompt):
					command = line.substr(prompt.length(), line.length() - prompt.length()).strip_edges()
				else:
					command = line.strip_edges()
				break
	
		if command == "quit":
			get_tree().quit()
		elif command == "play":
			get_tree().change_scene_to_file("res://scenes/IntroDialog.tscn")
		elif command == "help":
			text_edit.text = text_edit.text + "\nWelcome to The Resistance. Enter the command 'setuser <username>' to set your username, and 'setcomputer <computer name>' to set the name of your computer. Type 'play' to start. To close the application, enter 'quit'. Type 'help' to see this help menu again."
		else:
			text_edit.text = text_edit.text + "\nbash: " + command + ": command not found"
		
		text_edit.text = text_edit.text + "\n[user@computer ~]$ "
		var last_line = text_edit.get_line_count() - 1
		text_edit.set_caret_line(last_line)
		text_edit.set_caret_column(text_edit.get_line(last_line).length())
