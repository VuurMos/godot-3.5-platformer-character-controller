class_name PlatformController
extends KinematicBody2D

const TILE_SIZE := 16
var max_speed := 8 * TILE_SIZE
var current_speed := 0.0
var acceleration := 20 * TILE_SIZE
var friction := 20 * TILE_SIZE
# TODO: Jump Kinematics
var max_jump_height = 4 * TILE_SIZE
var min_jump_height = 2 * TILE_SIZE
var jump_duration = 0.25

#var jump_velocity = 2 * max_jump_height / jump_duration
var jump_gravity = 2 * max_jump_height / pow(jump_duration, 2)
var fall_gravity = 2 * min_jump_height / pow(jump_duration, 2)

var jump_velocity = -sqrt(2* jump_gravity * max_jump_height)

var jump_force := 300
var weak_gravity := 10
var strong_gravity := 20
var max_fall_velocity := 400
var max_air_jumps := 0
var current_air_jumps := 0
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


func _get_input_direction():
	var input = 0.0
	input = Input.get_action_strength("right") - Input.get_action_strength("left")
	return input

func check_direction_facing():
	if velocity.x > 0:
		_facing_right = true
		sprite.flip_h = false
	else:
		_facing_right = false
		sprite.flip_h = true


func add_jump_velocity():
	velocity.y = jump_velocity
	jump_buffer.stop()
	coyote_timer.stop()


func apply_jump_gravity():
	velocity.y += jump_gravity * get_physics_process_delta_time()


func apply_fall_gravity():
	velocity.y += fall_gravity * get_physics_process_delta_time()


# Apply movement with no acceleration or friction
func apply_movement():
	velocity.x = input_direction * max_speed
	# Clamp fall speed
	if velocity.y >= max_fall_velocity:
		velocity.y = max_fall_velocity
	velocity = move_and_slide(velocity, Vector2.UP)


#func apply_friction(_amount : float):
#	if velocity.x > _amount:
#		velocity.x -= velocity.x * _amount
#	else:
#		velocity.x = 0.0
#
#
#func apply_acceleration(_amount : float):
#	velocity.x += _amount
#	velocity.x = clamp(velocity.x, -max_speed, max_speed)
#
#
#func apply_movement_with_acc_and_fric():
#	if is_zero_approx(input_direction):
#		if !is_zero_approx(velocity.x):
#			apply_friction(friction * get_physics_process_delta_time())
#	else:
#		apply_acceleration(input_direction * acceleration * get_physics_process_delta_time())
#		check_direction_facing()

#	velocity.x = clamp(velocity.x, -max_speed, max_speed
#	if velocity.y >= max_fall_velocity:
#		velocity.y = max_fall_velocity
#	velocity = move_and_slide(velocity, Vector2.UP)
