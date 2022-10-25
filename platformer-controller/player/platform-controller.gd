class_name PlatformController
extends KinematicBody2D

var max_speed := 120
var acceleration := 500
var friction := 400
var _velocity := Vector2.ZERO
var _input_direction := 0.0
var _facing_right := true
onready var sprite = $Sprite
onready var jump_buffer = $JumpTimers/JumpBuffer
onready var coyote_timer = $JumpTimers/CoyoteTimer

func _input(event):
	if event.is_action_pressed("jump"):
		jump_buffer.start()

func _physics_process(delta):
	_input_direction = _get_input_direction()
	
	if is_zero_approx(_input_direction):
		if !is_zero_approx(_velocity.x):
			_apply_friction(friction * delta)
	else:
		_apply_acceleration(_input_direction * acceleration * delta)
		_check_direction_facing()
	
	if is_on_floor():
		coyote_timer.start()
		
		if !jump_buffer.is_stopped():
			_add_jump_force()
	else:
		_apply_gravity()
		
		if !coyote_timer.is_stopped() and !jump_buffer.is_stopped():
			_add_jump_force()
	
	_apply_movement()


func _get_input_direction():
	var input = 0.0
	input = Input.get_action_strength("right") - Input.get_action_strength("left")
	return input


func _apply_friction(_amount : float):
	if _velocity.x > _amount:
		_velocity.x -= _velocity.x * _amount
	else:
		_velocity.x = 0.0


func _apply_acceleration(_amount : float):
	_velocity.x += _amount
	_velocity.x = clamp(_velocity.x, -max_speed, max_speed)


func _check_direction_facing():
	if _input_direction > 0:
		_facing_right = true
		sprite.flip_h = false
	else:
		_facing_right = false
		sprite.flip_h = true


func _add_jump_force():
	_velocity.y = -200
	jump_buffer.stop()
	coyote_timer.stop()


func _apply_gravity():
	_velocity.y += 9.8


func _apply_movement():
	_velocity.x = _input_direction * max_speed
	_velocity = move_and_slide(_velocity, Vector2.UP)
