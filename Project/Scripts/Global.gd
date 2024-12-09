extends Node

var currentScene = null;

export var hoverNodes = [];

var playerNode;
onready var commandsNode = Ui.get_node_or_null("Commands");
onready var dialogsNode = Ui.get_node_or_null("Dialogs");
onready var imagesNode = Ui.get_node_or_null("Images");
onready var fadeNode = Ui.get_node_or_null("Fade")

var tweenNode;
var audioNode:AudioStreamPlayer;

var mouseMove:bool = true;
var mouseHover:bool = false;

var imageOpen:bool = false;
var dialogOpen:bool = false;
var dialogDone:bool = false;
var dialogClosing:bool = false;

var fadeScene:String = "";
var fading:bool = false;
var fadedOut:bool = false;
var warpPos:Vector2 = Vector2.ZERO;
var posPath:String

var muteAudio:bool = false;
onready var masterBus = AudioServer.get_bus_index("Master");


func _ready():
	Input.set_custom_mouse_cursor(load("res://UI/cursor.png"),Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(load("res://UI/cursor_select.png"),Input.CURSOR_POINTING_HAND,Vector2(14, 0))
	
	tweenNode = Tween.new();
	add_child(tweenNode);
	tweenNode.connect("tween_completed", self, "_on_tween_completed");
	
	audioNode = AudioStreamPlayer.new();
	add_child(audioNode);
	
	var root = get_tree().get_root();
	currentScene = root.get_children().back()
	init_nodes();


func mute_audio(mute):
	muteAudio = mute;
	AudioServer.set_bus_mute(masterBus, mute);


func init_nodes():
	playerNode = currentScene.get_node_or_null("Player");
	if (!playerNode):
		playerNode = currentScene.get_node_or_null("YSort/Player");
		if (!playerNode):
			playerNode = currentScene.get_node_or_null("%Player")
	
	if ("bgmTrack" in currentScene && audioNode.stream != currentScene.bgmTrack):
		audioNode.stream = currentScene.bgmTrack;
		audioNode.play();
	else:
		audioNode.stop()
		audioNode.stream = null


func fadeto_scene(path, pos):
	fading = true;
	fadeScene = path;
	posPath = pos; assert(pos != "", "warpPos needs the name of a Position2D!");
	var time = 0.3;
	tweenNode.interpolate_property(fadeNode,"color", Color(0,0,0,0), Color(0,0,0,1), time, Tween.TRANS_LINEAR, Tween.EASE_OUT);
	tweenNode.start();


func _on_tween_completed(_object, _key):
	if (fading):
		if (fadedOut):
			fadedOut = false;
			fading = false;
		else:
			fadedOut = true;
			goto_scene(fadeScene);
			var time = 0.3;
			tweenNode.interpolate_property(fadeNode,"color", Color(0,0,0,1), Color(0,0,0,0), time, Tween.TRANS_LINEAR, Tween.EASE_OUT);
			tweenNode.start();


func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path);


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	currentScene.free();

	# Load the new scene.
	var s = ResourceLoader.load(path); assert(ResourceLoader.exists(path) != false, "warpScene needs a valid filepath!");

	# Instance the new scene.
	currentScene = s.instance(); # if you get an error here, make sure the file path to the scene exists and hasn't been changed

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(currentScene);

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(currentScene);
	
	# Get and set the path of the Position2D node in the scene to warp to
	var posNode = get_tree().get_current_scene().get_node(posPath);
	assert(posNode != null, "warpPos needs to be a child of the scene root node!");
	assert(posNode.get_class() == "Position2D", "warpPos needs a Position2D!");
	
	warpPos = posNode.get_global_position()
	
	init_nodes();
	if (playerNode):
		playerNode.global_position = warpPos;


func _process(_delta):
	dialogOpen = false;
	if (dialogsNode.get_child_count() > 0):
		dialogOpen = true;
	imageOpen = false;
	if (imagesNode.get_child_count() > 0):
		imageOpen = true;
	
	if ((hoverNodes.size() > 0 && mouseHover == false && !dialogOpen)):
		mouseHover = true;
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	elif (hoverNodes.size() == 0 && mouseHover == true && !fading):
		mouseHover = false;
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
	mouseMove = !mouseHover && !dialogOpen && !fading;
	
	if Input.is_action_just_pressed("trickster_mode"):
		Signals.emit_signal("trickster")


func remove_commands():
	for child in commandsNode.get_children():
		child.queue_free();
