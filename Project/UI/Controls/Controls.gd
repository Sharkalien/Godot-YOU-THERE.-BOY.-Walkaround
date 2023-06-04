extends TextureButton

var dialog = """To walk around, use the mouse, arrow keys, or WASD keys. Click on various objects to open command menus for them!

Godot programming by Sharkalien and Axollyon (abyssalLotl).
Based on "[S] YOU THERE. BOY." from Homestuck (page 253).""";

var dialogBox = load("res://UI/Dialog Box/DialogPlayer.tscn")
var faded:bool = false;
const transTime = 0.2;


func _on_mouse_entered()->void:
	if (!Global.fading):
		Global.hoverNodes.append(self);


func _on_mouse_exited()->void:
	if (!Global.fading):
		Global.hoverNodes.erase(self);


func _process(_delta):
	if (Global.dialogOpen && !Global.dialogDone && !Global.dialogClosing && !faded):
		faded = true;
		$Tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0.5), transTime, Tween.TRANS_LINEAR, Tween.EASE_OUT);
		$Tween.start();
	elif (Global.dialogOpen && Global.dialogClosing && faded):
		faded = false;
		$Tween.interpolate_property(self, "modulate", Color(1,1,1,0.5), Color(1,1,1,1), transTime, Tween.TRANS_LINEAR, Tween.EASE_OUT);
		$Tween.start();


func _on_Controls_pressed() -> void:
	if (!Global.dialogOpen && !Global.imageOpen && !Global.fading):
		Global.remove_commands();
		var dialogBoxInstance = dialogBox.instance();
		Global.dialogsNode.add_child(dialogBoxInstance);
		dialogBoxInstance.dialog = dialog;
