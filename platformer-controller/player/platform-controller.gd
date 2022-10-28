class_name PlatformController
extends KinematicBody2D

const TILE_SIZE := 16

var velocity = Vector2.ZERO
var max_speed := 10 * TILE_SIZE

# TODO: Acceleration and deacceleration for movement
var acceleration_time := max_speed / 6 * 0.5
var deacceleration_time := max_speed / 3

var input_direction = 0.0
var _facing_right := true

var jump_input := false
var allow_double_jump := false

# Jump and fall kinematics
var jump_height = 4 * TILE_SIZE
var jump_x_dist = 3 * TILE_SIZE
var fall_x_dist = 1.75 * TILE_SIZE

var jump_velocity = (2 * jump_height * max_speed) / jump_x_dist

var jump_gravity = (2 * jump_height * pow(max_speed, 2)) / pow(jump_x_dist, 2)
var fall_gravity = (2 * jump_height * pow(max_speed, 2)) / pow(fall_x_dist, 2)

# Clamp fall speed
var max_fall_velocity = jump_velocity * 0.75

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
	print(velocity.x)
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
	velocity.y = -jump_velocity
	jump_buffer.stop()
	coyote_timer.stop()


func apply_jump_gravity():
	velocity.y += jump_gravity * get_physics_process_delta_time()


func apply_fall_gravity():
	velocity.y += fall_gravity * get_physics_process_delta_time()

# Apply movement with no acceleration or friction
func apply_movement():
	velocity.x = input_direction * max_speed
	clamp_fall_speed()
	velocity = move_and_slide(velocity, Vector2.UP)


func apply_smooth_movement():
	if is_zero_approx(input_direction):
		if !is_zero_approx(velocity.x):
			apply_friction()
	else:
		apply_acceleration()
		check_direction_facing()
	
	clamp_fall_speed()
	velocity = move_and_slide(velocity, Vector2.UP)


func apply_friction():
	velocity.x = move_toward(velocity.x, 0, deacceleration_time)


func apply_acceleration():
	velocity.x = move_toward(velocity.x, max_speed * input_direction, acceleration_time)


func clamp_fall_speed():
	if velocity.y >= max_fall_velocity:
		velocity.y = max_fall_velocity

#func apply_acc_movement():
#	if is_zero_approx(input_direction):
#		if !is_zero_approx(velocity.x):
#			apply_friction(deacceleration_time * get_physics_process_delta_time())
#	else:
#		apply_acceleration(input_direction * acceleration_time * get_physics_process_delta_time())
#		check_direction_facing()
#
#
#func apply_friction(_amount : float):
#	if velocity.x > _amount:
##		velocity.x.move_towards()
#		pass
#	else:
#		velocity.x = 0.0
#
#
#func apply_acceleration(_amount : float):
#	velocity.x += _amount
#	velocity.x = clamp(velocity.x, -max_speed, max_speed)
