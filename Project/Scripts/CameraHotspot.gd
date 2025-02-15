extends Area2D
class_name CameraHotspot

export (NodePath) onready var snapTo = get_node(snapTo) as Position2D
onready var remoteTransform:RemoteTransform2D
onready var camera = Global.currentScene.get_node_or_null("Camera2D")

var newPos:Vector2


func _ready() -> void:
	var hotspot = self
	hotspot.connect("body_entered", self, "_on_body_entered")
	hotspot.connect("body_exited", self, "_on_body_exited")
	
	remoteTransform = Global.playerNode.get_node_or_null("RemoteTransform2D")
	newPos = snapTo.get_global_position()

func _on_body_entered(body:PhysicsBody2D):
	if body == Global.playerNode:
		remoteTransform.set_update_position(false)
		assert(camera != null, "Camera2D needs to be a direct child of currentScene!")
		camera.set_global_position(newPos)

func _on_body_exited(body:PhysicsBody2D):
	if body == Global.playerNode:
		remoteTransform.set_update_position(true)
