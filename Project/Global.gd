extends Node2D

export var hoverNodes = [];

var playerNode;
var cameraNode;
var commandsNode;
var dialogsNode;

var mouseMove = true;
var mouseHover = false;
var dialogOpen = false;

func _ready():
	var root = get_tree().get_root().get_child(1);
	playerNode = root.get_node("Player");
	cameraNode = root.get_node("Camera2D");
	commandsNode = root.get_node_or_null("UI/Commands");
	dialogsNode = root.get_node_or_null("UI/Dialogs");

func _process(_delta):
	if (hoverNodes.size() > 0 && mouseHover == false && !dialogOpen):
		mouseHover = true;
		Input.set_custom_mouse_cursor(load("res://UI/cursor_select.png"),Input.CURSOR_ARROW,Vector2(14, 0))
	elif (dialogOpen || (hoverNodes.size() == 0 && mouseHover == true)):
		mouseHover = false;
		Input.set_custom_mouse_cursor(load("res://UI/cursor.png"))
		
	dialogOpen = false;
	if (dialogsNode):
		var cTrans = get_canvas_transform()
		var pos = -cTrans.get_origin() / cTrans.get_scale()
		dialogsNode.global_position = pos;
		if (dialogsNode.get_child_count() > 0):
			dialogOpen = true;
	
	mouseMove = !mouseHover && !dialogOpen;
		
func remove_commands():
	if (commandsNode):
		var count = commandsNode.get_child_count();
		for i in range(0, count):
			var child = commandsNode.get_child(i);
			commandsNode.remove_child(child);
			child.queue_free();
