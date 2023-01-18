extends Control

onready var label = get_node("CenterContainer/Body_NinePatchRect/MarginContainer/RichTextLabel");
onready var animPlayer = get_node("CenterContainer/Body_NinePatchRect/AnimationPlayer");

var dialog = "";
var typed = "";
var timer = 0;

var free = false;
var animDone = false

func _ready():
	animPlayer.play("Open")

func _process(_delta):
	if (!Global.dialogClosing && !free && animDone):
		if (timer < dialog.length() + 4):
			timer += 3;
			typed = dialog.left(timer);
			label.bbcode_text = typed + "";
		elif (!Global.dialogDone):
			Global.dialogDone = true;
			
		if Input.is_action_just_pressed("click") && timer > 10:
			if (!Global.dialogDone):
				timer = dialog.length() + 4;
				label.bbcode_text = dialog;
			else:
				label.bbcode_text = "";
				animPlayer.play_backwards("Open");
				Global.dialogClosing = true;
	
func _on_animation_finished(_anim):
	animDone = true
	if (Global.dialogClosing):
		Global.dialogDone = false;
		Global.dialogClosing = false;
		queue_free();
		free = true;
