extends Control

@onready var text_edit: TextEdit = $"."
@onready var directories = {
	"/": {
		"boot": {},
		"dev": {},
		"etc": {},
		"home": {
			Global.username: {
				"Documents": {
					"cool_beans.txt": "Network password: vhfxuh", 
					"placehold.txt": "this is a placeholder"
					},
			 	"Downloads": {
					"bird.png": "This is supposed to be an image of a bird, but pngs aren't supported!",
					"not_malware.zip": "This is very legit.", 
					"rabbit.png": "Bunnies are so fluffy and cute!"
					}
				}
			}
		}
	}
@onready var current_path = "/home/" + Global.username
@onready var dialog_node = $"../TextureRect2/RichTextLabel"
@onready var connected_to_wifi = false
@onready var command_is_running = false

func _ready():
	text_edit.text = "[" + Global.username + "@" + Global.computername + " " + current_path +"]$ "
	text_edit.gui_input.connect(_on_LineEdit_gui_input)
	
func _input(event):
	if event.is_action_pressed("ctrl+c"):
		command_is_running = false
	
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
	
		if command == "ls":
			var current = directories["/"]
			var path_parts = []
			
			for part in current_path.split("/"):
				if !part.is_empty():
					path_parts.append(part)
			
			for part in path_parts:
				if not current.has(part):
					text_edit.text += "\nNo such file or directory"
					text_edit.text = text_edit.text + "\n[user@computer ~]$ "
					var last_line = text_edit.get_line_count() - 1
					text_edit.set_caret_line(last_line)
					text_edit.set_caret_column(text_edit.get_line(last_line).length())
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
				var path_parts = []
				for path in current_path.split("/"):
					if !path.is_empty():
						path_parts.append(path)
				if path_parts.size() > 0:
					if arg == "..":
						path_parts.remove_at(path_parts.size() - 1)
					elif arg == "../..":
						path_parts.remove_at(path_parts.size() - 1)
						path_parts.remove_at(path_parts.size() - 1)
					elif arg == "../../..":
						path_parts.remove_at(path_parts.size() - 1)
						path_parts.remove_at(path_parts.size() - 1)
						path_parts.remove_at(path_parts.size() - 1)
					elif arg == "../../../..":
						path_parts.remove_at(path_parts.size() - 1)
						path_parts.remove_at(path_parts.size() - 1)
						path_parts.remove_at(path_parts.size() - 1)
						path_parts.remove_at(path_parts.size() - 1)
					
				current_path = "/" + "/".join(path_parts) if path_parts.size() > 0 else "/"
				print(current_path)
			elif arg.begins_with("/"):
				new_path = arg
				
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
				elif path_exists:
					text_edit.text += '\ncd: "' + arg + '" is not a directory'
				else: text_edit.text += '\ncd: The directory "' + arg + '" does not exist'
				
		elif command == "touch":
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
			
			if arg:
				current[arg] = ""
		
		elif command == "rm":
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
			
			if arg:
				current.erase(arg)
				
		elif command == "cat":
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
			
			if arg:
				if arg in current:
					if current[arg] is String:
						text_edit.text += "\n" + current[arg]
						if arg == "cool_beans.txt":
							dialog_node.catted_cool_beans()
					elif current[arg] is Dictionary:
						text_edit.text += "\ncat: " + arg + ": Is a directory"
				else:
					text_edit.text += "\ncat: " + arg + ": No such file or directory"
		
		elif command == "nmcli":
			if full_command == "nmcli device wifi list":
				text_edit.text += "\nSSID                         RATE             SIGNAL\nPurpleArmadillo   850 Mbit/s   96\nLazyPlumbers       900 Mbit/s   54\nTacos4Eva              560 Mbit/s   27"
				dialog_node.nmcli_list_completed()
			elif full_command.begins_with("nmcli device wifi connect"):
				if full_command == "nmcli device wifi connect PurpleArmadillo password secure":
					dialog_node.nmcli_connect_completed()
					text_edit.text += "\nConnection succesfull."
					connected_to_wifi = true
				else:
					text_edit.text += "\nConnection unsuccesfull. Incorrect SSID or password."
		
		elif command == "ping":
			if arg:
				if connected_to_wifi == true:
					if arg.ends_with(".com") or arg.ends_with(".net") or arg.ends_with(".org") or arg.ends_with(".io"):
						command_is_running = true
						while true:
							if command_is_running == false:
								text_edit.text += "\n^c"
								break
							text_edit.text += "\nsuccess"
							var last_line = text_edit.get_line_count() - 1
							text_edit.set_caret_line(last_line)
							text_edit.set_caret_column(text_edit.get_line(last_line).length())
							await get_tree().create_timer(1.0).timeout
							
					else:
						text_edit.text += "\nping: " + arg + ": Name or service not known"
				else:
					text_edit.text += "\nping: " + arg + ": Temporary failure in name resolution (make sure you are connected to the internet)."
			else:
				text_edit.text += "\nping: usage error: Destination address required"
		
		elif command == "pwd":
			text_edit.text += "\n" + current_path
		elif command == "clear":
			text_edit.text = "\n[" + Global.username + "@" + Global.computername + " " + current_path +"]$ "
			var last_line = text_edit.get_line_count() - 1
			text_edit.set_caret_column(text_edit.get_line(last_line).length())
			return
		elif command == "":
			null
		else:
			text_edit.text += "\nbash: " + command + ": command not found"
		
		text_edit.text += "\n[" + Global.username + "@" + Global.computername + " " + current_path +"]$ "
		var last_line = text_edit.get_line_count() - 1
		text_edit.set_caret_line(last_line)
		text_edit.set_caret_column(text_edit.get_line(last_line).length())
