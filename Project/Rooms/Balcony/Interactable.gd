extends Area2D

export (String, MULTILINE) var command = "";
export var width = 552;

export var isWarp = false;
export (String, MULTILINE) var dialogOrScene = "";

var commandBox = load("res://UI/Command Box/Command_Player.tscn")

func _on_mouse_entered()->void:
	if (!Global.fading):
		Global.hoverNodes.append(self);

func _on_mouse_exited()->void:
	if (!Global.fading):
		Global.hoverNodes.erase(self);
	
func _exit_tree():
	Global.hoverNodes.erase(self);

func _on_input_event(viewport, event, _shape_idx):
	if (Global.commandsNode && !Global.dialogOpen && !Global.fading && event is InputEventMouseButton && event.button_index == 1 && event.pressed == true):
		var commandBoxInstance = commandBox.instance();
		Global.remove_commands();
		Global.commandsNode.add_child(commandBoxInstance);
		var click = get_global_mouse_position();
		var cTrans = get_canvas_transform();
		var cScale = cTrans.get_scale();
		var right = (-cTrans.get_origin() / cScale + viewport.size / cScale).x;
		if (click.x + width > right):
			click.x = right - width;
		commandBoxInstance.global_position = click;
		commandBoxInstance.command = command;
		commandBoxInstance.get_node("CommandBox").rect_size.x = width;
		commandBoxInstance.get_node("CommandBox/NinePatchRect/MarginContainer/RichTextLabel").bbcode_text = command;
		commandBoxInstance.isWarp = isWarp;
		commandBoxInstance.dialogOrScene = dialogOrScene;
