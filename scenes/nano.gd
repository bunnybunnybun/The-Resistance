extends TextEdit

@onready var text_box = $"."
@onready var text_edit = $"../../Terminal"
@onready var file_editor = $"../"


func _input(event: InputEvent):
	if event.is_action_pressed("nano_exit"):
		text_box.accept_event()
		text_edit.visible = true
		file_editor.visible = false
	elif event.is_action_pressed("nano_save"):
		text_box.accept_event()
		var current = text_edit.directories["/"]
		var path_parts = []
		
		for part in text_edit.current_path.split("/"):
			if !part.is_empty():
				path_parts.append(part)
		
		for part in path_parts:
			if not current.has(part):
				text_edit.text += "No such file or directory"
				return
			current = current[part]
		
		if text_edit.arg:
			current[text_edit.arg] = text_box.text
