extends TextureButton

var dialog = """To walk around, use the mouse, arrow keys, or WASD keys. Click on various objects to open command menus for them!

Godot programming by Sharkalien and Axollyon (abyssalLotl).
Based on "[S] YOU THERE. BOY." from Homestuck (page 253)."""

var faded:bool = false
const transTime = 0.2

onready var clickThis:Sprite = $ClickThis


func _process(_delta):
	if Ui.dialogOpen && !Ui.dialogDone && !Ui.dialogClosing && !faded:
		faded = true
		$Tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0.5), transTime, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
	elif Ui.dialogOpen && Ui.dialogClosing && faded:
		faded = false
		$Tween.interpolate_property(self, "modulate", Color(1,1,1,0.5), Color(1,1,1,1), transTime, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()


func _on_Controls_pressed() -> void:
	if !Ui.dialogOpen && !Ui.imageOpen && !Ui.fading:
		Ui.remove_commands()
		var dialogBoxInstance = Ui.dialogBox.instance()
		dialogBoxInstance.dialog = dialog
		Ui.dialogsNode.add_child(dialogBoxInstance)
	if is_instance_valid(clickThis):
		clickThis.queue_free()
