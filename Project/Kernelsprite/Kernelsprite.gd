extends KinematicBody2D

#onready var spritePos:Vector2 = global_position
var spritePos:Vector2
var spriteFloat:float


func _physics_process(_delta: float) -> void:
	spritePos.x = spritePos.x + (Global.playerNode.position.x - spritePos.x) / 60
	position.x = spritePos.x
	spritePos.y += (Global.playerNode.position.y - spritePos.y) / 30
	spriteFloat += 0.1
	position.y = (spritePos.y + sin(spriteFloat) * 40) - 60
	
	if Global.playerNode.position.x != position.x:
		scale.x = scale.y * (abs(position.x - Global.playerNode.position.x) / (position.x - Global.playerNode.position.x))
