extends Control

var selected = false;

var texOn = load("res://UI/Audio/audio_on.png")
var texMute = load("res://UI/Audio/audio_mute.png")

var faded = false;
	
func _ready():
	if (Global.muteAudio):
		$Sprite.texture = texMute;
	else:
		$Sprite.texture = texOn;

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
	var time = 0.2;
	if (Global.dialogOpen && !Global.dialogDone && !Global.dialogClosing && !faded):
		faded = true;
		$Tween.interpolate_property($Sprite, "modulate", Color(1,1,1,1), Color(1,1,1,0.5), time, Tween.TRANS_LINEAR, Tween.EASE_OUT);
		$Tween.start();
	elif (Global.dialogOpen && Global.dialogClosing && faded):
		faded = false;
		$Tween.interpolate_property($Sprite, "modulate", Color(1,1,1,0.5), Color(1,1,1,1), time, Tween.TRANS_LINEAR, Tween.EASE_OUT);
		$Tween.start();
	
	if (Global.dialogsNode && !Global.dialogOpen && !Global.imageOpen && !Global.fading && selected && Input.is_action_just_pressed("click")):
		Global.remove_commands();
		if (Global.muteAudio):
			Global.mute_audio(false);
			$Sprite.texture = texOn;
		else:
			Global.mute_audio(true);
			$Sprite.texture = texMute;
