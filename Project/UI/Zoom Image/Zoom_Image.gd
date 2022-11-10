extends Control

var dialog = "";
var selected = false;
var dialogBoxInstance;
var dialogBox = load("res://UI/Dialog Box/Dialog_Player.tscn")
	
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
	if (Global.dialogsNode && !Global.dialogOpen && !Global.fading && selected && Input.is_action_just_pressed("click")):
		Global.remove_commands();
		dialogBoxInstance = dialogBox.instance();
		Global.dialogsNode.add_child(dialogBoxInstance);
		dialogBoxInstance.dialog = dialog;
		
	if (Global.dialogClosing):
		queue_free();
