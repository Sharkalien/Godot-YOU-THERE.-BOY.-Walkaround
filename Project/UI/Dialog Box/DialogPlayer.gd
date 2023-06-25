extends Control

onready var label:RichTextLabel = get_node("CenterContainer/Body_NinePatchRect/MarginContainer/RichTextLabel");
onready var animPlayer:AnimationPlayer = get_node("CenterContainer/Body_NinePatchRect/AnimationPlayer");

var dialog:String = "";
var timer:int = 0;
var free:bool = false;
var animDone:bool = false

func _ready():
	label.set_percent_visible(0.0)
	animPlayer.play("Open")
	call_deferred("set_dialog")

func _process(_delta):
	if (!Global.dialogClosing && !free && animDone):
		if (timer < dialog.length() + 3):
			timer += 3;
			label.visible_characters = timer;
		elif (!Global.dialogDone):
			Global.dialogDone = true;
			
		if Input.is_action_just_pressed("click") && timer > 10:
			if (!Global.dialogDone):
				timer = dialog.length();
				label.set_percent_visible(1.0);
			else:
				label.set_percent_visible(0.0);
				animPlayer.play_backwards("Open");
				Global.dialogClosing = true;

func set_dialog():
	label.set_bbcode(dialog)

func _on_animation_finished(_anim):
	animDone = true
	if (Global.dialogClosing):
		Global.dialogDone = false;
		Global.dialogClosing = false;
		queue_free();
		free = true;
