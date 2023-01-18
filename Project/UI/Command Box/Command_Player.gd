extends Control

onready var label:RichTextLabel = get_node("MarginContainer/VBoxContainer/RichTextLabel");
onready var commandBox = self
onready var COMMAND_MARGIN = get_node("MarginContainer/VBoxContainer").margin_left * 2

var command:String;
var dialog:String = """""";
var timer:int = 2; # to make "> " visible first
var color = "#ffffff"
var clicks:int = 0

var warpScene
var warpPos = "";
var zoomImage;

var imageBox = load("res://UI/Zoom Image/Zoom_Image.tscn")
var dialogBox = load("res://UI/Dialog Box/Dialog_Player.tscn")

func _ready() -> void:
	call_deferred("set_command")

func set_command():
	label.visible_characters = timer
	label.set_bbcode("> " + command)
	commandBox.rect_size.x = label.get_font("normal_font").get_string_size(label.text).x + COMMAND_MARGIN

func _process(_delta):
	if (timer < command.length() + 2):
		timer += 2;
		label.visible_characters = timer;
	label.bbcode_text = "[color=" + color + "]> " + command + "[/color]";
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
		if (warpScene != null && warpScene != ""):
			Global.fadeto_scene(warpScene, warpPos);
		elif (zoomImage && Global.imagesNode):
			var imageBoxInstance = imageBox.instance();
			Global.imagesNode.add_child(imageBoxInstance);
			imageBoxInstance.dialog = dialog;
			imageBoxInstance.get_node("ImageBox").texture = zoomImage; 
		elif ((dialog != """""" && dialog != "" && dialog != null) && Global.dialogsNode):
			var dialogBoxInstance = dialogBox.instance();
			Global.dialogsNode.add_child(dialogBoxInstance);
			dialogBoxInstance.dialog = dialog;
		else:
			pass
