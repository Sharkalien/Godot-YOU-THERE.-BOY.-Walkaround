extends Area2D

export (Array, Resource) var interactDialog = [Resource] # be sure to load in InteractDialog or InteractExtra
export (bool) var multiCommand = false

var clicks:int = 0
var selected:bool = false;
var commandBox = load("res://UI/Command Box/CommandPlayer.tscn")

func _ready():
	var interactable = self
	if interactable is Area2D and not null:
		interactable.connect("mouse_entered", self, "_on_mouse_entered")
		interactable.connect("mouse_exited", self, "_on_mouse_exited")

func _on_mouse_entered()->void:
	Global.hoverNodes.append(self);
	selected = true;

func _on_mouse_exited()->void:
	Global.hoverNodes.erase(self);
	selected = false;

func _exit_tree():
	Global.hoverNodes.erase(self);

func updateClicks():
	if clicks < interactDialog.size() - 1:
		clicks += 1
	else:
		clicks = 0

func _input(event):
	if (!Global.dialogOpen && !Global.imageOpen && !Global.fading && selected && event.is_action_released("click")):
		var commandBoxInstance = commandBox.instance();
		if multiCommand:
			commandBoxInstance.multiCommand = multiCommand
		commandBoxInstance.interactDialog = interactDialog
		Global.remove_commands();
		Global.commandsNode.add_child(commandBoxInstance);
		commandBoxInstance.connect("clicked", self, "updateClicks")
		commandBoxInstance.clicks = clicks
#		print(self)
		# Consume input and don't propagate it anymore. Keeps it from passing through one Area2D through another
		get_tree().set_input_as_handled()
