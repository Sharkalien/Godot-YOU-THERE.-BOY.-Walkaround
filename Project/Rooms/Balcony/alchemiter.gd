extends Area2D

var dialog = load("res://UI/Dialog Box/DialogBox.gd").new()

func _on_AlchemiterArea2D_mouse_entered()->void:
	Input.set_custom_mouse_cursor(load("res://UI/cursor_select.png"),Input.CURSOR_ARROW,Vector2(14, 0))


func _on_AlchemiterArea2D_mouse_exited()->void:
	Input.set_custom_mouse_cursor(load("res://UI/cursor.png"))


func _on_AlchemiterArea2D_input_event(viewport, event, shape_idx):
	pass # Replace with function body.
