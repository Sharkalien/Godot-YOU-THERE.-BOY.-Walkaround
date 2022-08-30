extends Area2D

export var width = 552; # there's probably a better way to get the width of a command that's automagic

export (Dictionary) var interactDialog = {"command": "", "dialog": ""}
export (Dictionary) var interactMisc = {"isWarp": false, "warpScene": "", "warpPos": Vector2.ZERO, "zoomImage": ""}

var selected = false;

var commandBox = load("res://UI/Command Box/Command_Player.tscn")

func _ready():
	var interactable = get_node(".")
	if interactable is Area2D and not null:
		interactable.connect("mouse_entered", self, "_on_mouse_entered")
		interactable.connect("mouse_exited", self, "_on_mouse_exited")

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
	if (Global.commandsNode && !Global.dialogOpen && !Global.imageOpen && !Global.fading && selected && Input.is_action_just_pressed("click")):
		var commandBoxInstance = commandBox.instance();
		Global.remove_commands();
		Global.commandsNode.add_child(commandBoxInstance);
		var click = get_viewport().get_mouse_position();
#		var cTrans = get_canvas_transform();
		var cTrans = get_viewport_transform();
		var cScale = cTrans.get_scale();
		var right = (-cTrans.get_origin() / cScale + get_viewport().size / cScale).x;
		if (click.x + width > right):
			click.x = right - width;
		# OOPS I SORT OF BROKE THE MATHS FOR THIS ^ MY BAD G
		commandBoxInstance.rect_global_position = click;
		commandBoxInstance.command = interactDialog.command;
		commandBoxInstance.dialog = interactDialog.dialog;
		commandBoxInstance.rect_size.x = width;
		commandBoxInstance.get_node("NinePatchRect/MarginContainer/RichTextLabel").bbcode_text = "";
		commandBoxInstance.isWarp = interactMisc.isWarp;
		commandBoxInstance.warpPos = interactMisc.warpPos;
		commandBoxInstance.warpScene = interactMisc.warpScene;
		commandBoxInstance.zoomImage = interactMisc.zoomImage;
