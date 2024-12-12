extends Control

var dialog:String = """"""
var selected:bool = false
var dialogBoxInstance
var dialogBox = load("res://UI/Dialog Box/DialogPlayer.tscn")
var imageTexture:Texture

func _ready() -> void:
	call_deferred("set_image_texture")

func set_image_texture():
	$ImageBox.texture = imageTexture

func _on_mouse_entered()->void:
	Global.hoverNodes.append(self)
	selected = true
	
func _on_mouse_exited()->void:
	Global.hoverNodes.erase(self)
	selected = false

func _exit_tree():
	Global.hoverNodes.erase(self)

func _process(_delta):
	if (!Global.dialogOpen && !Global.fading && selected && Input.is_action_just_pressed("click")):
		Global.remove_commands()
		if (!dialog.empty() && dialog != null):
			dialogBoxInstance = dialogBox.instance()
			Global.dialogsNode.add_child(dialogBoxInstance)
			dialogBoxInstance.dialog = dialog
	if (Global.dialogClosing):
		queue_free()

func _on_ImageBox_gui_input(_event: InputEvent) -> void:
	if ((dialog.empty() || dialog == null) && Input.is_action_just_pressed("click") && Global.imageOpen):
		queue_free()
