extends Node

onready var audioNode:AudioStreamPlayer = AudioStreamPlayer.new()
var tweenNode

var playerNode # player sets this as itself once it enters the tree
var oldPlayer

var currentScene = null
var fadeScene:String = ""
var warpPos:Vector2 = Vector2.ZERO
var posPath:String

var tricksterMode:bool = false


func _ready():
	Input.set_custom_mouse_cursor(load("res://UI/cursor.png"),Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(load("res://UI/cursor_select.png"),Input.CURSOR_POINTING_HAND,Vector2(14, 0))
	
	add_child(audioNode)
	tweenNode = Tween.new()
	add_child(tweenNode)
	tweenNode.connect("tween_completed", self, "_on_tween_completed")
	
	currentScene = get_tree().current_scene
	init_nodes()
	
	if !OS.has_feature("editor"):
		print(Engine.get_license_text()) # to comply with godot's license terms


func init_nodes():
	var currentSceneCanvasItem = currentScene.get_canvas_item()
	VisualServer.canvas_item_set_sort_children_by_y(currentSceneCanvasItem,true)
	if "bgmTrack" in currentScene && audioNode.stream == currentScene.bgmTrack || audioNode.stream == playerNode.trickSong:
		pass
	elif "bgmTrack" in currentScene && audioNode.stream != currentScene.bgmTrack:
		audioNode.stream = currentScene.bgmTrack
		audioNode.play()
	else:
		audioNode.stop()
		audioNode.stream = null


func fadeto_scene(path, pos):
	Ui.fading = true
	fadeScene = path
	posPath = pos; assert(pos != "", "warpPos needs the name of a Position2D!")
	var time = 0.3
	tweenNode.interpolate_property(Ui.fadeNode,"color", Color(0,0,0,0), Color(0,0,0,1), time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tweenNode.start()


func _on_tween_completed(_object, _key):
	if Ui.fading:
		if Ui.fadedOut:
			Ui.fadedOut = false
			Ui.fading = false
		else:
			Ui.fadedOut = true
			goto_scene(fadeScene)
			var time = 0.3
			tweenNode.interpolate_property(Ui.fadeNode,"color", Color(0,0,0,1), Color(0,0,0,0), time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			tweenNode.start()


# https://docs.godotengine.org/en/3.5/tutorials/scripting/singletons_autoload.html#custom-scene-switcher
func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.
	
	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	oldPlayer = playerNode
	currentScene.remove_child(oldPlayer)
	# It is now safe to remove the current scene
	currentScene.free()
	
	# Load the new scene.
	var s = ResourceLoader.load(path); assert(ResourceLoader.exists(path) != false, "warpScene needs a valid filepath!") # if you get an error here, make sure the file path to the scene exists and hasn't been changed
	
	# Instance the new scene.
	currentScene = s.instance()
	
	var newPlayer = currentScene.get_node("Player")
	currentScene.add_child_below_node(newPlayer,oldPlayer)
	var newPlayerRTPos:Vector2 = newPlayer.get_node("RemoteTransform2D").position
	newPlayer.free()
	playerNode = oldPlayer
	
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(currentScene)
	
	get_tree().set_current_scene(currentScene)
	
	# Get and set the path of the Position2D node in the scene to warp to
	var posNode = get_tree().get_current_scene().get_node(posPath)
	assert(posNode != null, "warpPos needs to be a child of the scene root node!")
	assert(posNode.get_class() == "Position2D", "warpPos needs a Position2D!")
	
	warpPos = posNode.get_global_position()
	
	if playerNode:
		playerNode.global_position = warpPos
		var playerRT = playerNode.get_node("RemoteTransform2D")
		playerRT.position = newPlayerRTPos
		var cam:Camera2D = currentScene.get_node("Camera2D")
		cam.global_position = playerRT.global_position
		cam.reset_smoothing()
	
	init_nodes()
