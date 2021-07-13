extends Node2D

var dialog = "To walk around, use the mouse, arrow keys, or WASD keys. Click on\nvarious objects to open command menus for them!\n\nGodot programming by Sharkalien and Axollyon (abyssalLotl).\nBased on \"[S] YOU THERE. BOY.\" from Homestuck (page 253).";

var dialogBox = load("res://UI/Dialog Box/Dialog_Player.tscn")
	
func _process(_delta):
	var cTrans = get_canvas_transform()
	global_position = -cTrans.get_origin() / cTrans.get_scale()
	
func _on_mouse_entered()->void:
	if (!Global.fading):
		Global.hoverNodes.append(self);
	
func _on_mouse_exited()->void:
	if (!Global.fading):
		Global.hoverNodes.erase(self);
	
func _exit_tree():
	Global.hoverNodes.erase(self);

func _on_gui_input(event):
	if (Global.dialogsNode && !Global.dialogOpen && !Global.fading && event is InputEventMouseButton && event.button_index == 1 && event.pressed == true):
		Global.remove_commands();
		var dialogBoxInstance = dialogBox.instance();
		Global.dialogsNode.add_child(dialogBoxInstance);
		dialogBoxInstance.dialog = dialog;
