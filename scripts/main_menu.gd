extends Control

@onready var text_edit: TextEdit = $TextEdit
@onready var label: Label = $Label
@onready var username = "username"
@onready var computername = "computer"

func _ready():
	text_edit.gui_input.connect(_on_LineEdit_gui_input)
	
func _on_LineEdit_gui_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		text_edit.accept_event()
		
		var line_count = text_edit.get_line_count()
		var full_command = ""
		var command = ""
		var arg = ""
		for i in range(line_count - 1, -1, -1):
			var line = text_edit.get_line(i)
			if not line.is_empty():
				var dollar_pos = line.find("$")
				if dollar_pos != -1:
					full_command = line.substr(dollar_pos + 1, line.length() - dollar_pos - 1).strip_edges()
				else:
					full_command = line.strip_edges()
					
				var command_parts = full_command.split(" ", false, 1)
				if command_parts.size() > 0:
					command = command_parts[0]
				if command_parts.size() > 1:
					arg = command_parts[1].strip_edges()
				break
	
		if command == "quit":
			get_tree().quit()
		elif command == "play":
			get_tree().change_scene_to_file("res://scenes/IntroDialog.tscn")
		elif command == "help":
			text_edit.text = text_edit.text + "\nWelcome to The Resistance. Enter the command 'setuser <username>' to set your username, and 'setcomputer <computer name>' to set the name of your computer. Type 'play' to start. To close the application, enter 'quit'. Type 'help' to see this help menu again."
		elif command == "setuser":
			Global.username = arg
		elif command == "setcomputer":
			Global.computername = arg
		else:
			text_edit.text = text_edit.text + "\nbash: " + command + ": command not found"
		
		text_edit.text = text_edit.text + "\n[" + Global.username + "@" + Global.computername + " /home/" + Global.username + "]$ "
		var last_line = text_edit.get_line_count() - 1
		text_edit.set_caret_line(last_line)
		text_edit.set_caret_column(text_edit.get_line(last_line).length())
