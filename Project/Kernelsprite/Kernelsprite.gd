extends KinematicBody2D

var spritePos:Vector2
var spriteFloat:float
onready var playerScale = Global.playerNode.get_node("PlayerArea2D")


#func _ready() -> void:
#	pass

func _physics_process(_delta: float) -> void:
	spritePos.x = spritePos.x + (Global.playerNode.position.x - spritePos.x) / 60
	self.position.x = spritePos.x
	spritePos.y += (Global.playerNode.position.y - spritePos.y) / 30
	spriteFloat += 0.1
	self.position.y = (spritePos.y + sin(spriteFloat) * 40) - 60
	
	if Global.playerNode.position.x != self.position.x:
		self.scale.x = playerScale.scale.x
#	print(spriteFloat)
