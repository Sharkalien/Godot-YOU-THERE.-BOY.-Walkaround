extends RichTextLabel

signal command_clicked

var command:String
var dialog:String = """"""
var warpScene
var warpPos = ""
var zoomImage
var extraFunc

var timer:int = 2 # to make "> " visible first
var clicks:int = 0
var width:int


func _ready() -> void:
	visible_characters = timer

func _process(_delta):
	if timer < command.length() + 2:
		timer += 2
		visible_characters = timer

func _on_CommandLabel_mouse_entered() -> void:
	Ui.hoverNodes.append(self)
	add_color_override("default_color",  Color(0.63, 0.63, 0.63))

func _on_CommandLabel_mouse_exited() -> void:
	Ui.hoverNodes.erase(self)
	remove_color_override("default_color")

func _exit_tree():
	Ui.hoverNodes.erase(self)


func _on_CommandLabel_gui_input(event: InputEvent) -> void:
	if !Ui.dialogOpen && event.is_action_pressed("click"):
		emit_signal("command_clicked")
		Ui.remove_commands()
		if zoomImage:
			Ui.add_image(zoomImage, dialog)
		elif !dialog.empty() && dialog != null:
			Ui.add_dialog(dialog)
		elif warpScene != null && !warpScene.empty():
			Global.fadeto_scene(warpScene, warpPos)
		else:
			pass
		if extraFunc:
			var extraFunction = Global.currentScene.get_node(extraFunc)
			if extraFunction.has_method("extraFunc"):
				extraFunction.extraFunc()
