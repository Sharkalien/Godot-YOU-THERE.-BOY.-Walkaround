extends KinematicBody2D

#onready var spritePos:Vector2 = global_position # uncomment this if you don't want the sprite to start moving from its parent's origin like in the original flash
var spritePos:Vector2
var spriteFloat:float
const SPEED:float = 0.06

onready var animPlayer := $AnimationPlayer


func _ready() -> void:
# warning-ignore:return_value_discarded
	Signals.connect("trickster", self, "tricksterMode")
	if Global.tricksterMode:
		tricksterMode()


func _physics_process(_delta: float) -> void:
	spritePos.x = spritePos.x + (Global.playerNode.position.x - spritePos.x) / 40
	position.x = spritePos.x
	spritePos.y += (Global.playerNode.position.y - spritePos.y) / 30
	spriteFloat += SPEED
	position.y = (spritePos.y + sin(spriteFloat) * 40) - 90
	
	if Global.playerNode.position.x != position.x:
		scale.x = scale.y * (abs(position.x - Global.playerNode.position.x) / (position.x - Global.playerNode.position.x))


func tricksterMode():
	if animPlayer.assigned_animation == "idle":
		animPlayer.play("tricksterMode")
	else:
		animPlayer.play("idle")
