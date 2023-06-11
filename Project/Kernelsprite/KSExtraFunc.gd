extends Node

export (NodePath) var ksBabbleAnimPlayer

func extraFunc():
	if ksBabbleAnimPlayer:
		var animPlayer: AnimationPlayer = get_node(ksBabbleAnimPlayer)
		animPlayer.play("babble")
