extends KinematicBody2D

const ACCELERATION = 30
const MAX_SPEED = 400
const FRICTION = 600

var velocity = Vector2.ZERO
var facing = "Front";

func _physics_process(_delta):
	movement()
	velocity = move_and_slide(velocity)

func movement():
	movementSmooth()
	
	# Controls player right and left animation sprites using arrow keys.
	if Input.is_action_pressed("ui_right"):
		$AnimationPlayer.play("run" + facing)
		$Sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		$AnimationPlayer.play("run" + facing)
		$Sprite.flip_h = true
	if Input.is_action_pressed("ui_up"):
		if facing != "Back":
			facing = "Back";
		$AnimationPlayer.play("run" + facing)
	elif Input.is_action_pressed("ui_down"):
		if facing != "Front":
			facing = "Front";
		$AnimationPlayer.play("run" + facing) 
	if Input.is_action_pressed("ui_right") && Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_up") && Input.is_action_pressed("ui_down"):
		$AnimationPlayer.play("still" + facing)

func movementSmooth():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION)
	else:
		$AnimationPlayer.play("still" + facing)
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
