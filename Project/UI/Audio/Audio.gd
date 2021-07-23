extends Node2D

var selected = false;

var texOn = load("res://UI/Audio/audio_on.png")
var texMute = load("res://UI/Audio/audio_mute.png")

var faded = false;
	
func _ready():
	if (Global.muteAudio):
		$AudioBox/Sprite.texture = texMute;
	else:
		$AudioBox/Sprite.texture = texOn;
	
func _on_mouse_entered()->void:
	if (!Global.fading):
		Global.hoverNodes.append(self);
		selected = true;
	
func _on_mouse_exited()->void:
	if (!Global.fading):
		Global.hoverNodes.erase(self);
		selected = false;
	
func _exit_tree():
	Global.hoverNodes.erase(self);

func _process(_delta):
	var cTrans = get_canvas_transform()
	global_position = -cTrans.get_origin() / cTrans.get_scale()
	
	var time = 0.2;
	if (Global.dialogOpen && !Global.dialogDone && !Global.dialogClosing && !faded):
		faded = true;
		$Tween.interpolate_property($AudioBox/Sprite, "modulate", Color(1,1,1,1), Color(1,1,1,0.5), time, Tween.TRANS_LINEAR, Tween.EASE_OUT);
		$Tween.start();
	elif (Global.dialogOpen && Global.dialogClosing && faded):
		faded = false;
		$Tween.interpolate_property($AudioBox/Sprite, "modulate", Color(1,1,1,0.5), Color(1,1,1,1), time, Tween.TRANS_LINEAR, Tween.EASE_OUT);
		$Tween.start();
	
	if (Global.dialogsNode && !Global.dialogOpen && !Global.imageOpen && !Global.fading && selected && Input.is_action_just_pressed("click")):
		Global.remove_commands();
		if (Global.muteAudio):
			Global.mute_audio(false);
			$AudioBox/Sprite.texture = texOn;
		else:
			Global.mute_audio(true);
			$AudioBox/Sprite.texture = texMute;
