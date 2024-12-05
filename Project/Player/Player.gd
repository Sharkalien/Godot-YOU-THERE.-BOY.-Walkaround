extends KinematicBody2D

const ACCELERATION = 30
const MAX_SPEED = 400
const FRICTION = 600

var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var facing = "Front";
var last_mouse_pos = null

var trickster := false

func _ready() -> void:
# warning-ignore:return_value_discarded
	Signals.connect("trickster", self, "tricksterMode")

func _physics_process(_delta):
	movement()
	velocity = move_and_slide(velocity)
	global_position = global_position.round()

func movement():
	if (Global.fading || Global.imageOpen):
		direction = Vector2.ZERO;
	else:
		keyMovement()
		mouseMovement()
	
	if (direction != Vector2.ZERO):
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	# Controls player right and left animation sprites using velocity.
	if (velocity == Vector2.ZERO):
		$AnimationPlayer.play("still" + facing)
	else:
		if !(Input.is_action_pressed("ui_left") && Input.is_action_pressed("ui_right")) || (velocity.x != 0 && last_mouse_pos != null):
			if Input.is_action_pressed("ui_right") || (velocity.x > 0 && last_mouse_pos != null):
				$AnimationPlayer.play("run" + facing)
				$Sprite.flip_h = false
				$PlayerInteractable.scale.x = 1;
			elif Input.is_action_pressed("ui_left") || (velocity.x < 0 && last_mouse_pos != null):
				$AnimationPlayer.play("run" + facing)
				$Sprite.flip_h = true
				$PlayerInteractable.scale.x = -1;
		if !(Input.is_action_pressed("ui_up") && Input.is_action_pressed("ui_down")) || (velocity.y != 0 && last_mouse_pos != null):
			if Input.is_action_pressed("ui_up") || (velocity.y < 0 && last_mouse_pos != null):
				if facing != "Back":
					facing = "Back";
				$AnimationPlayer.play("run" + facing)
			elif Input.is_action_pressed("ui_down") || (velocity.y > 0 && last_mouse_pos != null):
				if facing != "Front":
					facing = "Front";
				$AnimationPlayer.play("run" + facing) 

func keyMovement():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("ui_left", "ui_right");
	input_vector.y = Input.get_axis("ui_up", "ui_down");
	input_vector = input_vector.normalized();
	
	direction = input_vector;
	
	if input_vector != Vector2.ZERO:
		last_mouse_pos = null;

# Moves character to where mouse clicked. 
# Please refer to 
# https://www.youtube.com/watch?v=5bxys-Zo_jk&list=PLllc6qRBTEefSTIsPZVqhhuGNMc-5kOS6&index=16
func _unhandled_input(event):
	if OS.has_touchscreen_ui_hint():
		return
	elif Global.mouseMove && event.is_action_pressed("click"):
		Global.remove_commands();
		last_mouse_pos = get_global_mouse_position()

func mouseMovement():
	if last_mouse_pos:
		var input_vector = (last_mouse_pos - global_position)
		
		if input_vector.length() < 5 || (get_slide_count() > 0 && velocity != Vector2.ZERO):
			last_mouse_pos = null;
			return 
		
		direction = input_vector.normalized();


func tricksterMode():
	if !trickster:
		trickster = true
		$Sprite.rotation_degrees = 180
		set_collision_layer(0)
	else:
		trickster = false
		$Sprite.rotation_degrees = 0
		set_collision_layer(1)
