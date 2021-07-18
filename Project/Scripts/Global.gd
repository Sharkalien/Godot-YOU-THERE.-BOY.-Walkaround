extends CanvasModulate

var currentScene = null;

export var hoverNodes = [];

var playerNode;
var cameraNode;
var commandsNode;
var dialogsNode;
var imagesNode;

var tweenNode;
var audioNode;

var mouseMove = true;
var mouseHover = false;

var imageOpen = false;
var dialogOpen = false;
var dialogDone = false;
var dialogClosing = false;

var fadeScene = "";
var fading = false;
var fadedOut = false;
var warpPos = Vector2.ZERO;

var muteAudio = false;
var masterBus;

func _ready():
	tweenNode = Tween.new();
	add_child(tweenNode);
	tweenNode.connect("tween_completed", self, "_on_tween_completed");
	
	audioNode = AudioStreamPlayer.new();
	add_child(audioNode);
	masterBus = AudioServer.get_bus_index("Master");
	
	var root = get_tree().get_root();
	currentScene = root.get_child(root.get_child_count() - 1);
	init_nodes();
	
func mute_audio(mute):
	muteAudio = mute;
	AudioServer.set_bus_mute(masterBus, mute);

func init_nodes():
	playerNode = currentScene.get_node_or_null("Player");
	if (!playerNode):
		playerNode = currentScene.get_node_or_null("YSort/Player");
	cameraNode = currentScene.get_node_or_null("Camera2D");
	commandsNode = currentScene.get_node_or_null("UI/Commands");
	imagesNode = currentScene.get_node_or_null("UI/Images");
	dialogsNode = currentScene.get_node_or_null("UI/Dialogs");
	
	if ("bgmTrack" in currentScene && audioNode.stream != currentScene.bgmTrack):
		audioNode.stream = currentScene.bgmTrack;
		audioNode.play();
	
func fadeto_scene(path, pos):
	fading = true;
	fadeScene = path;
	warpPos = pos;
	var time = 0.3;
	tweenNode.interpolate_property(self,"color", Color(1,1,1,1), Color(0,0,0,1), time, Tween.TRANS_LINEAR, Tween.EASE_OUT);
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
			tweenNode.interpolate_property(self,"color", Color(0,0,0,1), Color(1,1,1,1), time, Tween.TRANS_LINEAR, Tween.EASE_OUT);
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
	var s = ResourceLoader.load(path);

	# Instance the new scene.
	currentScene = s.instance();

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(currentScene);

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(currentScene);
	
	init_nodes();
	if (playerNode):
		playerNode.global_position = warpPos;

func _process(_delta):
	dialogOpen = false;
	if (dialogsNode):
		if (dialogsNode.get_child_count() > 0 && dialogsNode.get_child(0).free == false):
			dialogOpen = true;
	imageOpen = false;
	if (imagesNode):
		if (imagesNode.get_child_count() > 0):
			imageOpen = true;
	
	if ((hoverNodes.size() > 0 && mouseHover == false && !dialogOpen) || (dialogOpen && dialogDone)):
		mouseHover = true;
		Input.set_custom_mouse_cursor(load("res://UI/cursor_select.png"),Input.CURSOR_ARROW,Vector2(14, 0))
	elif (dialogOpen || (hoverNodes.size() == 0 && mouseHover == true)):
		mouseHover = false;
		Input.set_custom_mouse_cursor(load("res://UI/cursor.png"))
	
	mouseMove = !mouseHover && !dialogOpen && !fading;
		
func remove_commands():
	if (commandsNode):
		var count = commandsNode.get_child_count();
		for i in range(0, count):
			var child = commandsNode.get_child(i);
			commandsNode.remove_child(child);
			child.queue_free();
