extends Node2D

var label;

var command = "";
var typed = "";
var timer = 0;
var color = "#ffffff"

func _ready():
	label = get_node("CommandBox/NinePatchRect/MarginContainer/RichTextLabel");
	
func _process(_delta):
	typed = command.left(timer);
	if (timer < command.length()):
		timer += 2;
	label.bbcode_text = "[color=" + color + "]" + typed + "[/color]";
	
func _on_mouse_entered()->void:
	Global.hoverNodes.append(self);
	color = "#a0a0a0";
	
func _on_mouse_exited()->void:
	Global.hoverNodes.erase(self);
	color = "#ffffff";
	
func _exit_tree():
	Global.hoverNodes.erase(self);

func _on_gui_input(_event):
	pass;
