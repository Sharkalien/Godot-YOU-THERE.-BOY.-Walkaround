extends Control

var dialog:String = """"""
var selected:bool = false
var imageTexture:Texture

func _ready() -> void:
	$ImageBox.texture = imageTexture

func _on_mouse_entered()->void:
	Ui.hoverNodes.append(self)
	selected = true

func _on_mouse_exited()->void:
	Ui.hoverNodes.erase(self)
	selected = false

func _enter_tree() -> void:
	Ui.imageOpen = true

func _exit_tree():
	Ui.imageOpen = false
	Ui.hoverNodes.erase(self)

func _process(_delta):
	if !Ui.dialogOpen && !Ui.fading && selected && Input.is_action_just_pressed("click"):
		Ui.remove_commands()
		if !dialog.empty() && dialog != null:
			var dialogBoxInstance = Ui.dialogBox.instance()
			dialogBoxInstance.dialog = dialog
			Ui.dialogsNode.add_child(dialogBoxInstance)
	if Ui.dialogClosing:
		queue_free()

func _on_ImageBox_gui_input(_event: InputEvent) -> void:
	if (dialog.empty() || dialog == null) && Input.is_action_just_pressed("click") && Ui.imageOpen:
		queue_free()
