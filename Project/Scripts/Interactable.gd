extends Area2D

export (Array, Resource) var interactDialog = [Resource] # be sure to load in InteractDialog or InteractExtra
export (bool) var multiCommand = false
export (NodePath) var extraFunc

var clicks:int = 0
var selected:bool = false
var commandBox = load("res://UI/Command Box/CommandPlayer.tscn")

func _ready():
	var interactable = self
	interactable.connect("mouse_entered", self, "_on_mouse_entered")
	interactable.connect("mouse_exited", self, "_on_mouse_exited")

func _on_mouse_entered()->void:
	Global.hoverNodes.append(self)
	selected = true

func _on_mouse_exited()->void:
	Global.hoverNodes.erase(self)
	selected = false

func _exit_tree():
	Global.hoverNodes.erase(self)

func updateClicks():
	if clicks < interactDialog.size() - 1:
		clicks += 1
	else:
		clicks = 0

func _process(_delta):
	if (!Global.dialogOpen && !Global.imageOpen && !Global.fading && selected && Input.is_action_just_pressed("click")):
		var commandBoxInstance = commandBox.instance()
		if multiCommand:
			commandBoxInstance.multiCommand = multiCommand
		commandBoxInstance.interactDialog = interactDialog
		Global.remove_commands()
		Global.commandsNode.add_child(commandBoxInstance)
		if !multiCommand:
			commandBoxInstance.connect("clicked", self, "updateClicks")
			commandBoxInstance.clicks = clicks
		if extraFunc:
			var extraFunction = get_node(extraFunc)
			if extraFunction.has_method("extraFunc"):
				commandBoxInstance.connect("clicked", extraFunction, "extraFunc")
