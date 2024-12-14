extends RichTextLabel


func _on_TricksterHint_gui_input(_event):
	if Input.is_action_just_released("click"):
		Signals.emit_signal("trickster")
