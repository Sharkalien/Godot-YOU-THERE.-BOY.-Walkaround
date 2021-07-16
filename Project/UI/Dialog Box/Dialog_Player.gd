extends Node2D

var label;
var animPlayer;

var dialog = "";
var typed = "";
var timer = 0;

var free = false;

func _ready():
	label = get_node("DialogBox/Body_NinePatchRect/MarginContainer/RichTextLabel");
	animPlayer = get_node("DialogBox/Body_NinePatchRect/AnimationPlayer");
	animPlayer.play("Open")

func _process(_delta):
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
