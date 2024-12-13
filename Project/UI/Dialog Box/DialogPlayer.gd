extends Control

onready var label:RichTextLabel = get_node("CenterContainer/Body_NinePatchRect/MarginContainer/RichTextLabel")
onready var animPlayer:AnimationPlayer = get_node("CenterContainer/Body_NinePatchRect/AnimationPlayer")

var dialog:String = ""
var queuedDialog:PoolStringArray
var timer:int = 0
var clicks:int = 0
var animDone:bool = false


func _ready():
	label.set_percent_visible(0.0)
	split_dialog()
	set_dialog()
	animPlayer.play("Open")


func _process(_delta):
	if !Ui.dialogClosing && animDone:
		if timer < label.get_total_character_count():
			timer += 3
			label.visible_characters = timer
		elif !Ui.dialogDone:
			Ui.dialogDone = true
			
		if Input.is_action_just_pressed("click"):
			if !Ui.dialogDone:
				timer = label.get_total_character_count()
				label.set_percent_visible(1.0)
			elif clicks < queuedDialog.size() - 1:
				clicks += 1
				dialog = queuedDialog[clicks].strip_edges()
				set_dialog()
			else:
				label.set_percent_visible(0.0)
				animPlayer.play_backwards("Open")
				Ui.dialogClosing = true


func split_dialog():
	if "{QUEUE_TEXT}" in dialog:
		queuedDialog = dialog.split("{QUEUE_TEXT}")
		dialog = queuedDialog[clicks].strip_edges()


func set_dialog():
	Ui.dialogDone = false
	label.set_percent_visible(0.0)
	timer = 0
	label.set_bbcode(dialog)


func _on_animation_finished(_anim):
	animDone = true
	if Ui.dialogClosing:
		Ui.dialogDone = false
		Ui.dialogClosing = false
		queue_free()


func _enter_tree() -> void:
	Ui.dialogOpen = true

func _exit_tree() -> void:
	Ui.dialogOpen = false
