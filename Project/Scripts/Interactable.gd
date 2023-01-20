extends Area2D

export (Array, Resource) var interactDialog = [Resource] # be sure to load in InteractDialog or InteractExtra
export (bool) var multiCommand = false

var clicks:int = 0
var selected:bool = false;
var commandBox = load("res://UI/Command Box/Command_Player.tscn")

func _ready():
	var interactable = self
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

func _process(_delta):
	if (Global.commandsNode && !Global.dialogOpen && !Global.imageOpen && !Global.fading && selected && Input.is_action_just_pressed("click")):
		var commandBoxInstance = commandBox.instance();
		Global.remove_commands();
		Global.commandsNode.add_child(commandBoxInstance);
		if multiCommand:
			commandBoxInstance.multiCommand = multiCommand
		commandBoxInstance.interactDialog = interactDialog
#		clicks = interactDialog[clicks].clicks
