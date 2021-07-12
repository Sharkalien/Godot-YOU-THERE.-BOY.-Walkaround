extends Node

export var hoverNodes = [];

var playerNode;
var cameraNode;
var commandsNode;

var mouseMove = true;
var mouseHover = false;

func _ready():
	var root = get_tree().get_root().get_child(1);
	playerNode = root.get_node("Player");
	cameraNode = root.get_node("Camera2D");
	commandsNode = root.get_node_or_null("UI/Commands");

func _process(_delta):
	if (hoverNodes.size() > 0 && mouseHover == false):
		mouseHover = true;
		mouseMove = false;
		Input.set_custom_mouse_cursor(load("res://UI/cursor_select.png"),Input.CURSOR_ARROW,Vector2(14, 0))
	elif (hoverNodes.size() == 0 && mouseHover == true):
		mouseHover = false;
		mouseMove = true;
		Input.set_custom_mouse_cursor(load("res://UI/cursor.png"))
		
func remove_commands():
	if (commandsNode):
		var count = commandsNode.get_child_count();
		for i in range(0, count):
			var child = commandsNode.get_child(i);
			commandsNode.remove_child(child);
			child.queue_free();
