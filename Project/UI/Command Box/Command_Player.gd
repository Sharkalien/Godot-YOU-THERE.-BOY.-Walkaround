extends Control

onready var label = load("res://UI/Command Box/CommandLabel.tscn");
onready var commandBox = self
onready var commandContainer = get_node("MarginContainer/VBoxContainer")
onready var COMMAND_MARGIN = get_node("MarginContainer/VBoxContainer").margin_left * 2
onready var root = get_tree().get_root()
onready var labelInstance:RichTextLabel = label.instance()

var dict:Dictionary = {"command": "", "dialog": """""", "warpScene": null, "warpPos": "", "zoomImage": null}
var interactDialog:Array
var multiCommand:bool = false

var command:String;
var dialog:String = """""";
var timer:int = 2; # to make "> " visible first
var color = "#ffffff"
var clicks:int = 0
var width:int;

var warpScene
var warpPos = "";
var zoomImage;

var imageBox = load("res://UI/Zoom Image/Zoom_Image.tscn")
var dialogBox = load("res://UI/Dialog Box/Dialog_Player.tscn")

func _ready() -> void:
	commandContainer.add_child(labelInstance)
	call_deferred("check_interactable_dict", labelInstance)
	call_deferred("set_command")

func check_interactable_dict(instance):
	for key in dict:
		if key in interactDialog[clicks]:
			instance.set(key, interactDialog[clicks].get(key))

func set_command():
	labelInstance.visible_characters = timer
	labelInstance.set_bbcode("> " + labelInstance.command)
	commandBox.rect_size.x = labelInstance.get_font("normal_font").get_string_size(labelInstance.text).x + COMMAND_MARGIN
	width = commandBox.rect_size.x
	var click; # uhhh just ignore any errors you might get here, it happens when two or more interactables overlap each other, but at least it doesn't cause the game to crash. I guess that's the problem with using overlapping Area2Ds, you can't limit the input to just one :P
	if get_viewport():
		click = get_global_mouse_position()
	else:
		click = Vector2.ZERO
	var cTrans = Ui.get_transform();
	var cScale = cTrans.get_scale();
	var right = (-cTrans.get_origin() / cScale + root.size / cScale).x;
	if (width > root.size.x):
		width = root.size.x
		commandBox.rect_size.x = width
	if (click.x + width > right):
		click.x = right - width;
	commandBox.rect_global_position = Vector2(click.x, click.y - 9); # the flash has a particular offset

func _process(_delta):
	if (timer < labelInstance.command.length() + 2):
		timer += 2;
		labelInstance.visible_characters = timer;
#	labelInstance.bbcode_text = "[color=" + color + "]> " + labelInstance.command + "[/color]";
#	if (Global.fading || Global.dialogOpen):
#		color = "#ffffff";

func _on_gui_input(event):
#	pass
	if (!Global.dialogOpen && !Global.fading && event is InputEventMouseButton && event.button_index == 1 && event.pressed == true):
		Global.remove_commands();
#		if (zoomImage && Global.imagesNode):
#			var imageBoxInstance = imageBox.instance();
#			Global.imagesNode.add_child(imageBoxInstance);
#			if (dialog != """""" && dialog != "" && dialog != null):
#				imageBoxInstance.dialog = dialog;
#			imageBoxInstance.imageTexture = zoomImage;
#		elif ((dialog != """""" && dialog != "" && dialog != null) && Global.dialogsNode):
#			var dialogBoxInstance = dialogBox.instance();
#			Global.dialogsNode.add_child(dialogBoxInstance);
#			dialogBoxInstance.dialog = dialog;
#		elif (warpScene != null && warpScene != ""):
#			Global.fadeto_scene(warpScene, warpPos);
#		else:
#			pass
