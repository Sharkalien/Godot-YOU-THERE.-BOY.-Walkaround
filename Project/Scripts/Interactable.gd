extends Area2D

export (String, MULTILINE) var command = "";
export var width = 552;

export var isWarp = false;
export (String, MULTILINE) var dialogOrScene = "";
export var warpPos = Vector2.ZERO;
export (Texture) var zoomImage;

var selected = false;

var commandBox = load("res://UI/Command Box/Command_Player.tscn")

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
		var click = get_global_mouse_position();
		var cTrans = get_canvas_transform();
		var cScale = cTrans.get_scale();
		var right = (-cTrans.get_origin() / cScale + get_viewport().size / cScale).x;
		if (click.x + width > right):
			click.x = right - width;
		commandBoxInstance.global_position = click;
		commandBoxInstance.command = command;
		commandBoxInstance.get_node("CommandBox").rect_size.x = width;
		commandBoxInstance.get_node("CommandBox/NinePatchRect/MarginContainer/RichTextLabel").bbcode_text = "";
		commandBoxInstance.isWarp = isWarp;
		commandBoxInstance.warpPos = warpPos;
		commandBoxInstance.dialogOrScene = dialogOrScene;
		commandBoxInstance.zoomImage = zoomImage;
