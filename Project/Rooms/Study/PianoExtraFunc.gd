extends Node

export (AudioStream) var hauntingRefrain

func extraFunc():
	Global.audioNode.stream = hauntingRefrain
	Global.audioNode.play()
