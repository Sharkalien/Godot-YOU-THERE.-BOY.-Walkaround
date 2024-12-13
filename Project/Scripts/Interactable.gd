extends Area2D

export (Array, Resource) var interactDialog = [Resource] # be sure to load in InteractDialog or InteractExtra
export (bool) var multiCommand = false
export (NodePath) var extraFunc

var clicks:int = 0
var selected:bool = false

func _ready():
	var interactable = self
	interactable.connect("mouse_entered", self, "_on_mouse_entered")
	interactable.connect("mouse_exited", self, "_on_mouse_exited")

func _on_mouse_entered()->void:
	Ui.hoverNodes.append(self)
	selected = true

func _on_mouse_exited()->void:
	Ui.hoverNodes.erase(self)
	selected = false

func _exit_tree():
	Ui.hoverNodes.erase(self)

func updateClicks():
	if clicks < interactDialog.size() - 1:
		clicks += 1
	else:
		clicks = 0

func _process(_delta):
	if !Ui.dialogOpen && !Ui.imageOpen && !Ui.fading && selected && Input.is_action_just_pressed("click"):
		var commandBoxInstance = Ui.commandBox.instance()
		commandBoxInstance.interactDialog = interactDialog
		if multiCommand:
			commandBoxInstance.multiCommand = multiCommand
		else:
			commandBoxInstance.connect("clicked", self, "updateClicks")
			commandBoxInstance.clicks = clicks
		if extraFunc:
			var extraFunction = get_node(extraFunc)
			if extraFunction.has_method("extraFunc"):
				commandBoxInstance.connect("clicked", extraFunction, "extraFunc")
		Ui.remove_commands()
		Ui.commandsNode.add_child(commandBoxInstance)
