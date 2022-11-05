class_name PlatformController
extends KinematicBody2D

const TILE_SIZE := 16

var velocity := Vector2.ZERO
var max_speed := 10 * TILE_SIZE
var acceleration_time := max_speed / 6
var deacceleration_time := max_speed / 3

var input_direction := Vector2.ZERO
var _facing_right := true

var jump_input := false

# Jump and fall kinematics
var jump_height = 5 * TILE_SIZE
var jump_x_dist = 3.5 * TILE_SIZE
var fall_x_dist = 1.75 * TILE_SIZE

var jump_velocity = (2 * jump_height * max_speed) / jump_x_dist
var jump_gravity = (2 * jump_height * pow(max_speed, 2)) / pow(jump_x_dist, 2)

var low_grav_apex_threshold = -25
var jump_apex_gravity = jump_gravity * 0.3

var quick_fall_gravity = (2 * jump_height * pow(max_speed, 2)) / pow(fall_x_dist, 2)
var fall_gravity = quick_fall_gravity * 0.4
var max_fall_velocity = jump_velocity * 0.85

var dash_input := false
var dash_duration := 0.1
# Rough estimate of average modifier value over the dash duration. Estimate is duration dependent.
var avg_dash_velocity_modifier := 0.92
var dash_distance := 3 * TILE_SIZE
# Estimated velocity required to travel the desired distance over the dash. 
var est_dash_velocity := dash_distance / (dash_duration * avg_dash_velocity_modifier)

onready var sprite = $Sprite
onready var cam = $PlayerCamera
onready var jump_buffer = $StateTimers/JumpBuffer
onready var coyote_timer = $StateTimers/CoyoteTimer
onready var fall_timer = $StateTimers/FallTimer
onready var dash_cooldown = $StateTimers/DashCooldown
onready var state_machine = $StateMachine
onready var state_label = $StateLabel


func _ready():
	cam.target = self
	state_machine.connect("transitioned", state_label, "update_label")


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


func add_dash_velocity(_dash_direction, _dash_velocity_modifier):
	velocity.x = est_dash_velocity * _dash_velocity_modifier * _dash_direction


func apply_gravity(_gravity):
	velocity.y += _gravity * get_physics_process_delta_time()


func apply_friction():
	velocity.x = move_toward(velocity.x, 0, deacceleration_time)


func apply_acceleration():
	velocity.x = move_toward(velocity.x, max_speed * input_direction.x, acceleration_time)


func clamp_fall_speed():
	if velocity.y >= max_fall_velocity:
		velocity.y = max_fall_velocity


func apply_movement():
	velocity = move_and_slide(velocity, Vector2.UP)
