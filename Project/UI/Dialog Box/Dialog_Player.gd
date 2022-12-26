extends Control

onready var label = get_node("CenterContainer/Body_NinePatchRect/MarginContainer/RichTextLabel");
onready var animPlayer = get_node("CenterContainer/Body_NinePatchRect/AnimationPlayer");

var dialog = "";
var typed = "";
var timer = 0;

var free = false;

func _ready():
	animPlayer.play("Open")

func _process(_delta):
#	print(dialog)
#	dialog = dialog.replace("\\n", "\n") #argh, this makes very short dialogs such as "...\n\nOk." freeze for some reason
	if (!Global.dialogClosing && !free):
		if (timer < dialog.length() + 2):
			timer += 2;
			typed = dialog.left(timer);
			label.bbcode_text = typed + "";
		elif (!Global.dialogDone):
			Global.dialogDone = true;
			
		if Input.is_action_just_pressed("click") && timer > 10:
			if (!Global.dialogDone):
				timer = dialog.length() + 2;
				label.bbcode_text = dialog;
			else:
				animPlayer.play_backwards("Open");
				label.bbcode_text = "";
				Global.dialogClosing = true;
	
func _on_animation_finished(_anim):
	if (Global.dialogClosing):
		Global.dialogDone = false;
		Global.dialogClosing = false;
		queue_free();
		free = true;
