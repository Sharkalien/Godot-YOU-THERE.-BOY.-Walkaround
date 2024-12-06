extends Control

signal clicked

onready var root = get_tree().get_root()
onready var commandBox = self
onready var commandContainer = get_node("MarginContainer/VBoxContainer")
onready var COMMAND_MARGIN = get_node("MarginContainer/VBoxContainer").margin_left * 2
const label = preload("res://UI/Command Box/CommandLabel.tscn");
var labelInstance:RichTextLabel = label.instance()

var dict:Dictionary = {"command": "", "dialog": """""", "warpScene": null, "warpPos": "", "zoomImage": null}
var interactDialog:Array
var multiCommand:bool = false

var clicks:int = 0
var width:int;
var height:int;


func _ready() -> void:
	commandContainer.add_child(labelInstance)
# warning-ignore:return_value_discarded
	labelInstance.connect("command_clicked", self, "clicked")
	call_deferred("check_interactable_dict", labelInstance)
	call_deferred("set_command")

func clicked():
	emit_signal("clicked")

func check_interactable_dict(instance):
	for key in dict:
		if key in interactDialog[clicks]:
			instance.set(key, interactDialog[clicks].get(key))

func set_command():
	if multiCommand:
		pass
#		print("true")
#		print(interactDialog.size())
	
	labelInstance.set_bbcode("> " + labelInstance.command)
	commandBox.rect_size.x = labelInstance.get_font("normal_font").get_string_size(labelInstance.text).x + COMMAND_MARGIN
	width = commandBox.rect_size.x
	height = commandBox.rect_size.y
	
	var click;
	if get_viewport():
		click = get_global_mouse_position()
	else:
		click = Vector2.ZERO
	var cTrans = Ui.get_transform();
	var cScale = cTrans.get_scale();
	var right = (-cTrans.get_origin() / cScale + root.size / cScale).x;
	if (width > root.size.x):
		width = root.size.x
		commandBox.rect_size.x = width
	if (click.x + width > right):
		click.x = right - width;
	commandBox.rect_global_position = Vector2(click.x, click.y - 9); # the flash has a particular offset
