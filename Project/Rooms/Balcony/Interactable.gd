extends Area2D

export var command = "";
export var width = 552;

var commandBox = load("res://UI/Command Box/Command_Player.tscn")

func _on_mouse_entered()->void:
	Global.hoverNodes.append(self);

func _on_mouse_exited()->void:
	Global.hoverNodes.erase(self);
	
func _exit_tree():
	Global.hoverNodes.erase(self);

func _on_input_event(viewport, event, _shape_idx):
	if (Global.commandsNode && event is InputEventMouseButton && event.button_index == 1 && event.pressed == true):
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
