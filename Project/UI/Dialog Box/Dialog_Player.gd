extends Node2D

var label;
var animPlayer;

var dialog = "";
var typed = "";
var timer = 0;

var closing = false;

func _ready():
	label = get_node("DialogBox/Body_NinePatchRect/MarginContainer/RichTextLabel");
	animPlayer = get_node("DialogBox/Body_NinePatchRect/AnimationPlayer");
	animPlayer.play("Open")

func _process(_delta):
	typed = dialog.left(timer);
	if (timer < dialog.length() + 2 && !closing):
		timer += 2;
		label.bbcode_text = typed + "";
	if Input.is_action_just_pressed("click") && timer > 10:
		animPlayer.play_backwards("Open");
		label.bbcode_text = "";
		closing = true;
	
func _on_animation_finished(_anim):
	if (closing):
		queue_free();
