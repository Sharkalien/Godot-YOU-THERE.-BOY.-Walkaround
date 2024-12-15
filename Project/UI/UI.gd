extends CanvasLayer

onready var imagesNode = $Images
onready var dialogsNode = $Dialogs
onready var commandsNode = $Commands
onready var fadeNode = $Fade

var imageBox = load("res://UI/Zoom Image/ZoomImage.tscn")
var dialogBox = load("res://UI/Dialog Box/DialogPlayer.tscn")
var commandBox = load("res://UI/Command Box/CommandPlayer.tscn")
const label = preload("res://UI/Command Box/CommandLabel.tscn")

var imageOpen:bool = false
var dialogOpen:bool = false
var dialogDone:bool = false
var dialogClosing:bool = false

var hoverNodes:Array = []
var mouseMove:bool = true
var mouseHover:bool = false
var fading:bool = false
var fadedOut:bool = false

func _process(_delta):	
	if hoverNodes.size() > 0 && mouseHover == false && !dialogOpen:
		mouseHover = true
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	elif hoverNodes.size() == 0 && mouseHover == true && !fading:
		mouseHover = false
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func add_dialog(dialog:String):
	var dialogBoxInstance = Ui.dialogBox.instance()
	dialogBoxInstance.dialog = dialog
	Ui.dialogsNode.add_child(dialogBoxInstance)


func add_image(texture:Texture, dialog:String):
	var imageBoxInstance = imageBox.instance()
	if !dialog.empty() && dialog != null:
		imageBoxInstance.dialog = dialog
	imageBoxInstance.imageTexture = texture
	imagesNode.add_child(imageBoxInstance)


func add_commands(interactable):
	var commandBoxInstance = commandBox.instance()
	commandBoxInstance.interactDialog = interactable.interactDialog
	if interactable.multiCommand:
		commandBoxInstance.multiCommand = interactable.multiCommand
	else:
		commandBoxInstance.connect("clicked", interactable, "updateClicks")
		commandBoxInstance.clicks = interactable.clicks
	if interactable.extraFunc:
		var extraFunction = interactable.get_node(interactable.extraFunc)
		if extraFunction.has_method("extraFunc"):
			commandBoxInstance.connect("clicked", extraFunction, "extraFunc")
	remove_commands()
	commandsNode.add_child(commandBoxInstance)


func remove_commands():
	for child in commandsNode.get_children():
		child.queue_free()
