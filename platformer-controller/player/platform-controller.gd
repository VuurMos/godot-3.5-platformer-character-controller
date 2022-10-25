class_name PlatformController
extends KinematicBody2D

var max_speed := 120
var acceleration := 500
var friction := 400
var jump_force := 200
var weak_gravity := 10
var strong_gravity := 20
var max_fall_velocity := 400
var velocity := Vector2.ZERO
var input_direction := 0.0
var jump_input := false
var _facing_right := true
onready var sprite = $Sprite
onready var jump_buffer = $JumpTimers/JumpBuffer
onready var coyote_timer = $JumpTimers/CoyoteTimer
onready var state_machine = $StateMachine
onready var state_label = $StateLabel

func _ready():
	state_machine.connect("transitioned", state_label, "update_label")


func _input(event):
	# Check if jump input has been pressed (recently with buffer)
	if event.is_action_pressed("jump"):
		jump_input = true
		jump_buffer.start()
	
	# Check if should cancel jump early
	if event.is_action_released("jump"):
		jump_input = false


func _physics_process(delta):
	input_direction = _get_input_direction()
	print(velocity.y)


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
	velocity.y = -jump_force
	jump_buffer.stop()
	coyote_timer.stop()


func apply_gravity(gravity):
	velocity.y += gravity


func apply_movement():
	velocity.x = input_direction * max_speed
	velocity = move_and_slide(velocity, Vector2.UP)


func clamp_fall_velocity():
	if velocity.y > max_fall_velocity:
		velocity.y = max_fall_velocity
