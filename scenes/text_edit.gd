extends Control

@onready var text_edit: TextEdit = $"."
@onready var directories = {
	"/": {
		"boot": [],
		"dev": [],
		"etc": [],
		"home": {
			"user": {
				"Documents": ["Secrets.txt", "placehold.txt"],
			 	"Downloads": ["bird.png", "not_malware.zip", "rabbit.png"]
			}
		}
	}
}
#"home": ["Documents", "Downloads"],
	#"Documents": ["Secrets.txt", "placehold.txt"],
	#"Downloads": ["bird.png", "not_malware.zip", "rabbit.png"]
#@onready var home = ["Documents", "Downloads"]
@onready var current_path = "/"
#@onready var Documents = ["Secrets.txt", "placehold.txt"]

func _ready():
	text_edit.gui_input.connect(_on_LineEdit_gui_input)
	
func _on_LineEdit_gui_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		text_edit.accept_event()
		
		var line_count = text_edit.get_line_count()
		var prompt = "[user@computer ~]$ "
		var full_command = ""
		var command = ""
		var arg = ""
		for i in range(line_count - 1, -1, -1):
			var line = text_edit.get_line(i)
			if not line.is_empty():
				if line.begins_with(prompt):
					full_command = line.substr(prompt.length(), line.length() - prompt.length()).strip_edges()
				else:
					full_command = line.strip_edges()
					
				var command_parts = full_command.split(" ", false, 1)
				if command_parts.size() > 0:
					command = command_parts[0]
				if command_parts.size() > 1:
					arg = command_parts[1].strip_edges()
				break
	
		if command == "ls":
			var current = directories["/"]
			var path_parts = []
			
			for part in current_path.split("/"):
				if !part.is_empty():
					path_parts.append(part)
			
			for part in path_parts:
				if not current.has(part):
					text_edit.text += "No such file or directory"
					return
				current = current[part]
			
			text_edit.text += "\n"
			if current is Dictionary:
				for item in current.keys():
					text_edit.text += item + "\n"
			elif current is Array:
				for item in current:
					text_edit.text += item + "\n"
		elif command == "cd": # Yes, this command is quite janky (like everything). I should redo it at some point, but I'll never finish if I try perfecting everything D:
			var new_path = current_path
			if !new_path.ends_with("/"):
				new_path += "/"
				
			if arg == ".":
				null
			elif arg.begins_with("..") and current_path != "/":
				print("test succesful")
				var path_parts = []
				for path in current_path.split("/"):
					if !path.is_empty():
						path_parts.append(path)
				if path_parts.size() > 0:
					if arg == "..":
						path_parts.remove_at(path_parts.size() - 1)
					elif arg == "../..":
						path_parts.remove_at(path_parts.size() - 2)
					elif arg == "../../..":
						path_parts.remove_at(path_parts.size() - 3)
					elif arg == "../../../..":
						path_parts.remove_at(path_parts.size() - 4)
					
				current_path = "/".join(path_parts) if path_parts.size() > 0 else "/"
				print(current_path)
			else:
				new_path += arg
				
				var current = directories["/"]
				var path_parts = []
				for path in new_path.split("/"):
					if !path.is_empty():
						path_parts.append(path)
				var path_exists = true
				
				for part in path_parts:
					if current.has(part):
						current = current[part]
					else:
						path_exists = false
						break
				
				if path_exists and current is Dictionary:
					current_path = new_path
				else: text_edit.text += '\ncd: The directory "' + arg + '" does not exist'
				
		elif command == "help":
			text_edit.text = text_edit.text + "\nWelcome to The Resistance. Enter the command 'setuser <username>' to set your username, and 'setcomputer <computer name>' to set the name of your computer. Type 'play' to start. To close the application, enter 'quit'. Type 'help' to see this help menu again."
		elif command == "":
			null
		else:
			text_edit.text = text_edit.text + "\nbash: " + command + ": command not found"
		
		text_edit.text = text_edit.text + "\n[user@computer ~]$ "
		var last_line = text_edit.get_line_count() - 1
		text_edit.set_caret_line(last_line)
		text_edit.set_caret_column(text_edit.get_line(last_line).length())
