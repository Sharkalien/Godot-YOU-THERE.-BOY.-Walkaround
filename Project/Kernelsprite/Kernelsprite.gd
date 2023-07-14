extends KinematicBody2D

#onready var spritePos:Vector2 = global_position
var spritePos:Vector2
var spriteFloat:float

onready var animPlayer := $AnimationPlayer


func _ready() -> void:
# warning-ignore:return_value_discarded
	Signals.connect("trickster", self, "tricksterMode")


func _physics_process(_delta: float) -> void:
	spritePos.x = spritePos.x + (Global.playerNode.position.x - spritePos.x) / 40
	position.x = spritePos.x
	spritePos.y += (Global.playerNode.position.y - spritePos.y) / 30
	spriteFloat += 0.07
	position.y = (spritePos.y + sin(spriteFloat) * 40) - 90
	
	if Global.playerNode.position.x != position.x:
		scale.x = scale.y * (abs(position.x - Global.playerNode.position.x) / (position.x - Global.playerNode.position.x))


func tricksterMode():
	if animPlayer.assigned_animation == "idle":
		animPlayer.play("tricksterMode")
	else:
		animPlayer.play("idle")
