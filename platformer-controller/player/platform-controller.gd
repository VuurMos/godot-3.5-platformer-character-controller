class_name PlatformController
extends KinematicBody2D

var max_speed := 120
var acceleration := 500
var friction := 400
var velocity := Vector2.ZERO
var input_direction := 0.0
var jump_input := false
var _facing_right := true
onready var sprite = $Sprite
onready var jump_buffer = $JumpTimers/JumpBuffer
onready var coyote_timer = $JumpTimers/CoyoteTimer

func _input(event):
	# Check if jump input has been pressed (recently with buffer)
	if event.is_action_pressed("jump"):
		jump_input = true
		jump_buffer.start()
	
	# Check if should cancel jump early
	if event.is_action_released("jump"):
		jump_input = false
		pass


func _physics_process(delta):
	input_direction = _get_input_direction()


func _get_input_direction():
	var input = 0.0
	input = Input.get_action_strength("right") - Input.get_action_strength("left")
	return input


func apply_friction(_amount : float):
	if velocity.x > _amount:
		velocity.x -= velocity.x * _amount
	else:
		velocity.x = 0.0


func apply_acceleration(_amount : float):
	velocity.x += _amount
	velocity.x = clamp(velocity.x, -max_speed, max_speed)


func check_direction_facing():
	if velocity.x > 0:
		_facing_right = true
		sprite.flip_h = false
	else:
		_facing_right = false
		sprite.flip_h = true


func add_jump_force():
	velocity.y = -200
	jump_buffer.stop()
	coyote_timer.stop()


func apply_gravity():
	velocity.y += 9.8


func apply_movement():
	velocity.x = input_direction * max_speed
	velocity = move_and_slide(velocity, Vector2.UP)
