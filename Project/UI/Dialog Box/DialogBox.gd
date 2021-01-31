extends Control

var dialog = [
	'The ALCHEMITER created the APPLE, or the tree that sprouted it rather, right on time to save you from destruction. You\'re not sure if you can say the same for your neighborhood though.\n\nYou wonder what happened to your DAD?',
	'...\n\nWhat?',
	'His name is John.'
]

var dialog_index = 0
var finished = false

func _ready():
	load_dialog()

func _process(_delta):
	if Input.is_action_just_pressed("click"):
		load_dialog()

func load_dialog():
	if dialog_index < dialog.size():
		$Body_NinePatchRect/MarginContainer/RichTextLabel.bbcode_text = dialog[dialog_index]
		$Body_NinePatchRect/MarginContainer/RichTextLabel.percent_visible = 0
		$Body_NinePatchRect/MarginContainer/RichTextLabel/Tween.interpolate_property(
			$Body_NinePatchRect/MarginContainer/RichTextLabel, "percent_visible", 0, 1, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Body_NinePatchRect/MarginContainer/RichTextLabel/Tween.start()
	else:
		queue_free()
	dialog_index += 1
