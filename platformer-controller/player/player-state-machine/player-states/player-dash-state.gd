# Dash state
extends PlayerState

var dash_direction := 0
var current_dash_time := 0.0
var dash_starting_pos := 0.0
var dash_ending_pos := 0.0

func enter(msg := {}) -> void:
	player.velocity.y = 0.0
	current_dash_time = 0.0
	dash_starting_pos = player.global_position.x
	
	# TODO: Change facing direction based on input
	if player.input_direction.x > 0:
		dash_direction = 1
	elif player.input_direction.x < 0:
		dash_direction = -1
	else:
		if player._facing_right:
			dash_direction = 1
		else:
			dash_direction = -1
	
	player.dash_cooldown.start()


func physics_update(delta: float) -> void:
	if player.is_on_floor():
		# These prevent the player from bumping the ground during the dash
		player.velocity.y = 0
		player.apply_gravity(player.fall_gravity)
		player.clamp_fall_speed()
	else:
		player.velocity.y = 0
	
	current_dash_time += delta
	var dash_progress = current_dash_time / player.dash_duration
	
	var dash_velocity_modifier = 1 - pow(2, -10 * dash_progress)
	print("delta: " + str(delta))
	print("dash progress: " + str(dash_progress))
	print("dash velocity: " + str(dash_velocity_modifier))
	
	player.add_dash_velocity(dash_direction, dash_velocity_modifier)
	player.check_direction_facing()
	player.apply_movement()
	
	if current_dash_time >= player.dash_duration:
		if !player.is_on_floor():
			state_machine.transition_to("Fall")
			return
		
		if player.is_on_floor():
			if is_zero_approx(player.input_direction.x):
				state_machine.transition_to("Idle")
			else:
				state_machine.transition_to("Move")


func exit() -> void:
	player.dash_input = false
	dash_ending_pos = player.global_position.x
	print("dash distance total: " + str(dash_ending_pos - dash_starting_pos))
