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


func remove_commands():
	for child in commandsNode.get_children():
		child.queue_free()


func _process(_delta):	
	if hoverNodes.size() > 0 && mouseHover == false && !dialogOpen:
		mouseHover = true
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	elif hoverNodes.size() == 0 && mouseHover == true && !fading:
		mouseHover = false
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
