extends RichTextLabel


func _on_TricksterHint_gui_input(event):
	if event.is_pressed():
		Signals.emit_signal("trickster")
