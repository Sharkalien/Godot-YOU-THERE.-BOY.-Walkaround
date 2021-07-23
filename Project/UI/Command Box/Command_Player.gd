extends Node2D

var label;

var command = "";
var typed = "";
var timer = 0;
var color = "#ffffff"

var isWarp = false;
var dialogOrScene = "";
var warpPos = Vector2.ZERO;
var zoomImage;

var imageBox = load("res://UI/Zoom Image/Zoom_Image.tscn")
var dialogBox = load("res://UI/Dialog Box/Dialog_Player.tscn")

func _ready():
	label = get_node("CommandBox/NinePatchRect/MarginContainer/RichTextLabel");
	
func _process(_delta):
	typed = command.left(timer);
	if (timer < command.length() + 2):
		timer += 2;
	label.bbcode_text = "[color=" + color + "]" + typed + "[/color]";
	if (Global.fading || Global.dialogOpen):
		color = "#ffffff";
	
func _on_mouse_entered()->void:
	if (!Global.fading):
		Global.hoverNodes.append(self);
		if (!Global.dialogOpen):
			color = "#a0a0a0";
	
func _on_mouse_exited()->void:
	if (!Global.fading):
		Global.hoverNodes.erase(self);
		if (!Global.dialogOpen):
			color = "#ffffff";
	
func _exit_tree():
	Global.hoverNodes.erase(self);

func _on_gui_input(event):
	if (!Global.dialogOpen && !Global.fading && event is InputEventMouseButton && event.button_index == 1 && event.pressed == true):
		Global.remove_commands();
		if (isWarp):
			Global.fadeto_scene(dialogOrScene, warpPos);
		elif (zoomImage && Global.imagesNode):
			var imageBoxInstance = imageBox.instance();
			Global.imagesNode.add_child(imageBoxInstance);
			imageBoxInstance.dialog = dialogOrScene;
			imageBoxInstance.get_node("ImageBox/Sprite").texture = zoomImage; 
		elif (Global.dialogsNode):
			var dialogBoxInstance = dialogBox.instance();
			Global.dialogsNode.add_child(dialogBoxInstance);
			dialogBoxInstance.dialog = dialogOrScene;
