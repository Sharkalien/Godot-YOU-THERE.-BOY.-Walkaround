extends Area2D

export var width = 552; # there's probably a better way to get the width of a command that's automagic

export (Array, Resource) var interactDialog = [Resource] # be sure to load in InteractDialog or InteractExtra

var dict:Dictionary = {"command": "", "dialog": """""", "warpScene": null, "warpPos": Vector2.ZERO, "zoomImage": null}

export (bool) var multiCommand = false

var clicks:int = 0
var selected = false;
var commandBox = load("res://UI/Command Box/Command_Player.tscn")

func _ready():
	var interactable = get_node(".")
	if interactable is Area2D and not null:
		interactable.connect("mouse_entered", self, "_on_mouse_entered")
		interactable.connect("mouse_exited", self, "_on_mouse_exited")

func _on_mouse_entered()->void:
	if (!Global.fading):
		Global.hoverNodes.append(self);
		selected = true;

func _on_mouse_exited()->void:
	if (!Global.fading):
		Global.hoverNodes.erase(self);
		selected = false;

func _exit_tree():
	Global.hoverNodes.erase(self);

func check_interactable_dict(instance):
	for key in dict:
		if key in interactDialog[clicks]:
			instance.set(key, interactDialog[clicks].get(key))

func _process(_delta):
	if (Global.commandsNode && !Global.dialogOpen && !Global.imageOpen && !Global.fading && selected && Input.is_action_just_pressed("click")):
		var commandBoxInstance = commandBox.instance();
		Global.remove_commands();
		Global.commandsNode.add_child(commandBoxInstance);
		var click = get_viewport().get_mouse_position();
#		var cTrans = get_canvas_transform();
		var cTrans = get_viewport_transform();
		var cScale = cTrans.get_scale();
		var right = (-cTrans.get_origin() / cScale + get_viewport().size / cScale).x;
		commandBoxInstance.get_node("MarginContainer/VBoxContainer/RichTextLabel").bbcode_text = "";
		check_interactable_dict(commandBoxInstance)
		width = commandBoxInstance.rect_size.x
		if (click.x + width > right):
			click.x = right - width;
		# OOPS I SORT OF BROKE THE MATHS FOR THIS ^ MY BAD G
		print(clicks)
		commandBoxInstance.rect_global_position = Vector2(click.x, click.y - 16); # hack way of centering the commandbox at the cursor
#		commandBoxInstance.rect_size.x = commandBoxInstance.label.get_font("normal_font").get_string_size(commandBoxInstance.label.text).x + 30;
#		clicks = interactDialog[clicks].clicks
