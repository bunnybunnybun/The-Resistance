extends RichTextLabel

@onready var label: = $"."
@onready var label2: = $"../../Label2"
@onready var current_dialog = 1
@onready var dialogs = {
	1: "Ah, I can see you don't even know where to begin with using this machine... Let me teach you the basics.\n\nThe text that's currently on your screen is called the 'prompt', the first word is your username, the second is the name of your computer. The part right after the computer name shows what directory/folder you are currently in. ",
	2: "Speaking of directories, let's see what's [i]inside[/i] the current directory. You can do this by using the command 'ls'. It will print the names of all folders and files within the current directory.         \n\nTry that now.         \n\nThen, you can navigate into one of the folders that is inside of your current directory by doing 'cd <folder name>'. For example, to move into the Downloads folder, type 'cd Downloads'.        \n\nThe file-system can be thought of as a hierarchy, or a tree. To go back to up to the parent directory (which is higher in the hierarchy, or a branch closer to the trunk of the tree), you can do 'cd ..'.",
	3: "The file-system starts at the \"/\" directory, often called the root directory (in our hierarchy example, this would be the very top of the hierarchy).\nWhen we moved into the Downloads folder, we did that by entering the [i]relative[/i] path to it, but we could also use the full path, like this: 'cd /home/user/Downloads'. A full path always starts with a '/' symbol, while relative paths do not.",
	4: "Now, I shall assign you a task! Okay, that sounds dramatic... What I want you to do is connect to the internet. To do this, we will use a utility called 'nmcli'. First of all, we can see a list of available networks with the command 'nmcli device wifi list'. Do that!",
	5: "The first network in the list, the one called \"PurpleArmadillo\", that's the one we want! But we can't connect to it without the password, which unfortunately I do not remember... But I wrote it down in a file called \"cool_beans.txt\"! Of course, just storing a password in a file on your computer isn't very secure, so I encrypted the password with a cipher to keep it safe, but we'll deal with the cipher part in a minute. First, let's just print the contents of the file.\n\nFirst, navigate to the 'Documents' directory (Remember, we can do that with the command 'cd'). Now, if you do 'ls', you should see the cool_beans.txt file. To see the contents of that file, we can use the 'cat' command, like this: 'cat <file_name>'.",
	6: "Alright, now that we have the password, it's time to decrypt it. I encrypted it using an algorithm called the Caesar Cipher, which just shifts each letter over to the right in the alphabet by 3 places. So for example, the letter C would become F. An example of a full word being encrypted using this method would be this: bunny → exqqb. But how does a character at the end of the alphabet, like Z, get encrypted? It simply wraps around to the beginning of the alphabet, to become C.\n\nAnd finally, to [i]decrypt[/i] it, we just do the exact opposite! We shift every individual letter in the encrypted password over 3 spaces to the [i]left[/i]! Do that now to the password that we found, and when you're done, see if it's correct by attempting to connect to the wifi with it using this command: 'nmcli device wifi connect <SSID/name> password <decrypted password>'.",
	7: "Great! Let's test it now, by pinging a website to make sure our wifi is working. Ping the website of your choice with 'ping <website_name>'.\n          \nYou see how it is now continually pinging the site over and over, with no signs of stopping? Whenever a program continues running like this, and you want to stop it, you can use the keybind 'ctrl + c' to kill it.",
	8: "Now that we have access to the internet, let's download a program called \"tldr\". What this program does, is it gives you a simple explanation for how basically any command works, and how to use it. On Linux, you often have access to a tool called a package manager, which makes installing software very easy. We will use the 'apt' package manager to install tldr, like this: 'apt install tldr'.\n\nOnce you've installed it, use it by simply typing 'tldr <command>' to get info about almost any command you want.",
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
	if current_dialog == 4:
		label2.text = "Complete the task to continue..."
	if current_dialog == 7:
		label2.text = "Press f1 to continue..."
	label2.visible = true
	
func _input(event):
	if Input.is_action_just_pressed("continue_in_dialog") and label2.visible == true and label2.text == "Press f1 to continue...":
		label.accept_event()
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
func nmcli_list_completed():
	if current_dialog == 4 and label2.visible == true:
		label.accept_event()
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
			
func catted_cool_beans():
	if current_dialog == 5 and label2.visible == true:
		label.accept_event()
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

func nmcli_connect_completed():
	if current_dialog == 6 and label2.visible == true:
		label.accept_event()
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
