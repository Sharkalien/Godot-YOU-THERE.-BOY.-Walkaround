extends Control

onready var animPlayer = get_node("CenterContainer/Body_NinePatchRect/AnimationPlayer")

func _ready():
	animPlayer.play("Open")
