# Dash state
extends PlayerState

var dash_direction := 0
var current_dash_time := 0.0
var dash_duration := 0.2
var minimum_dash_progress := 0.5


func enter(msg := {}) -> void:
	player.velocity.y = 0.0
	player.dashing = true
	current_dash_time = 0.0
	
	if player.input_direction.x > 0:
		dash_direction = 1
	elif player.input_direction.x < 0:
		dash_direction = -1
	else:
		if player._facing_right:
			dash_direction = 1
		else:
			dash_direction = -1

func physics_update(delta: float) -> void:
	if player.is_on_floor():
		player.velocity.y = 0
		player.apply_fall_gravity()
		player.clamp_fall_speed()
	
	current_dash_time += delta
	var dash_progress = current_dash_time / dash_duration
	
	var dash_velocity = 1 - pow(2, -10 * dash_progress)
	
	player.add_dash_velocity(dash_direction, dash_velocity)
	player.apply_movement()
	
	# Leave state
	if current_dash_time >= dash_duration:
		if !player.is_on_floor():
			state_machine.transition_to("Fall", {from_ground = true})
			return
		
		if player.is_on_floor():
			state_machine.transition_to("Move")

func exit() -> void:
	player.dashing = false
	player.dash_input = false
