extends Control

signal clicked

onready var root = get_tree().get_root()
onready var commandBox = self
onready var commandContainer = get_node("MarginContainer/VBoxContainer")
const label = preload("res://UI/Command Box/CommandLabel.tscn");
var labelInstance:RichTextLabel = label.instance()
onready var COMMAND_MARGIN = labelInstance.get("custom_styles/normal").get_margin(MARGIN_LEFT) * 2

var dict:Dictionary = {"command": "", "dialog": """""", "warpScene": null, "warpPos": "", "zoomImage": null}
var interactDialog:Array
var multiCommand:bool = false

var clicks:int = 0
var width:int;
var lastWidth:int
var lastHeight:int
var height:int;


func _ready() -> void:
	commandContainer.add_child(labelInstance)
# warning-ignore:return_value_discarded
	labelInstance.connect("command_clicked", self, "clicked")
	call_deferred("check_interactable_dict", labelInstance)
	if !multiCommand:
		call_deferred("set_command", labelInstance)
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
	if width < lastWidth:
		width = lastWidth
		commandBox.rect_size.x = width
	lastHeight = commandBox.rect_size.y
	if height < lastHeight:
		height = lastHeight
		
	
	var click;
	if get_viewport():
		var mousePos := get_global_mouse_position()
		click = Vector2(mousePos.x, mousePos.y - 16) # center the command where clicked
	else:
		click = Vector2.ZERO
		push_warning("no viewport?")
	var viewportWidth = root.get_visible_rect().size.x
	var viewportHeight = root.get_visible_rect().size.y
	if (width > viewportWidth):
		width = viewportWidth
		commandBox.rect_size.x = width
	if (click.x + width > viewportWidth):
		click.x = viewportWidth - width;
	if height > viewportHeight:
		height = viewportHeight
	if click.y + height > viewportHeight:
		click.y = viewportHeight - height
	commandBox.rect_global_position = Vector2(click.x, click.y);


func set_multicommand():
	commandContainer.get_child(0).queue_free()
	for i in interactDialog:
#		yield(get_tree(), "idle_frame")
		var lab  = label.instance()
		commandContainer.add_child(lab)
		for key in dict:
			if key in i:
				lab.set(key, i.get(key))
		call_deferred("set_command", lab)
