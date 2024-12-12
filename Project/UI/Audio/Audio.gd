extends TextureButton

onready var masterBus = AudioServer.get_bus_index("Master")
const transTime = 0.2
var faded = false


func _process(_delta):
	if Global.dialogOpen && !Global.dialogDone && !Global.dialogClosing && !faded:
		faded = true
		$Tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0.5), transTime, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
	elif Global.dialogOpen && Global.dialogClosing && faded:
		faded = false
		$Tween.interpolate_property(self, "modulate", Color(1,1,1,0.5), Color(1,1,1,1), transTime, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()


func _on_Audio_toggled(button_pressed: bool) -> void:
		AudioServer.set_bus_mute(masterBus, button_pressed)
