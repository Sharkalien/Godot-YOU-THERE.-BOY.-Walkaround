extends Control

signal clicked

onready var root = get_tree().get_root()
onready var commandBox = self
onready var commandContainer = get_node("MarginContainer/VBoxContainer")
var labelInstance:RichTextLabel = Ui.label.instance()
onready var COMMAND_MARGIN = labelInstance.get("custom_styles/normal").get_margin(MARGIN_LEFT) * 2

var dict:Dictionary = {"command": "", "dialog": """""", "warpScene": null, "warpPos": "", "zoomImage": null}
var interactDialog:Array
var multiCommand:bool = false

var clicks:int = 0
var width:int
var lastWidth:int
var lastHeight:int
var height:int

var newLabel:RichTextLabel

func _ready() -> void:
	if !multiCommand:
		add_label()
	# warning-ignore:return_value_discarded
		newLabel.connect("command_clicked", self, "clicked")
		call_deferred("check_interactable_dict", newLabel)
		call_deferred("set_command", newLabel)
	else:
		call_deferred("set_multicommand")

func clicked():
	emit_signal("clicked")

func check_interactable_dict(instance):
	for key in dict:
		if key in interactDialog[clicks]:
			instance.set(key, interactDialog[clicks].get(key))

func set_command(labelInst):
	labelInst.set_bbcode("> " + labelInst.command)
	lastWidth = labelInst.get_font("normal_font").get_string_size(labelInst.text).x + COMMAND_MARGIN
	var viewportWidth = root.get_visible_rect().size.x
	var viewportHeight = root.get_visible_rect().size.y
	var mousePos := get_global_mouse_position()
	var click = Vector2(mousePos.x, mousePos.y - 16) # center the command where clicked
	
	if width < lastWidth:
		width = lastWidth
		commandBox.rect_size.x = width
	lastHeight = commandBox.rect_size.y
	if height < lastHeight:
		height = lastHeight
	
	if width > viewportWidth:
		width = viewportWidth
		commandBox.rect_size.x = width
		yield(self, "resized") # height could be taller now if the command label wraps around on a new line, so it needs to wait to update the size before setting the new height
	height = commandBox.rect_size.y
	if height > viewportHeight:
		height = viewportHeight
	
	if click.x + width > viewportWidth:
		click.x = viewportWidth - width
	if click.y + height > viewportHeight:
		click.y = viewportHeight - height
	if click.y < 0:
		click.y = 0
	commandBox.rect_global_position = Vector2(click.x, click.y)


func add_label():
	var instance = Ui.label.instance()
	commandContainer.add_child(instance)
	newLabel = instance


func set_multicommand():
	for i in interactDialog:
		add_label()
		for key in dict:
			if key in i:
				newLabel.set(key, i.get(key))
		call_deferred("set_command", newLabel)
