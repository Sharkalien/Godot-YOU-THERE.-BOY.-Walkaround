extends Area2D

export (NodePath) onready var snapTo = get_node(snapTo) as Position2D
onready var remoteTransform:RemoteTransform2D

var old_position:Vector2
var new_position:Vector2


func _ready() -> void:
	var hotspot = self
	if hotspot is Area2D and not null:
		hotspot.connect("body_entered", self, "_on_body_entered")
		hotspot.connect("body_exited", self, "_on_body_exited")
	
	assert(Global.currentScene.get_node_or_null("%Player") != null, "Access Player as Scene Unique Name when using hotspots!")
	remoteTransform = Global.currentScene.get_node_or_null("%Player").get_node_or_null("RemoteTransform2D")
	old_position = remoteTransform.get_position()
	new_position = snapTo.get_global_position()

func _on_body_entered(body:PhysicsBody2D):
	if body.get_class() == "KinematicBody2D":
		remoteTransform.set_global_position(new_position)

func _on_body_exited(body:PhysicsBody2D):
	if body.get_class() == "KinematicBody2D":
		remoteTransform.set_position(old_position)
