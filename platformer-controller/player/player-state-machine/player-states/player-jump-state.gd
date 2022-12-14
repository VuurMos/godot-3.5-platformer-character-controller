# Air State
extends PlayerAirState


func enter(msg := {}) -> void:
	player.velocity.y = 0
	player.add_jump_velocity()


func physics_update(delta: float) -> void:
	# Jump cancel (variable jump height)
	if !player.jump_input:
		player.apply_gravity(player.quick_fall_gravity)
	else:
		if player.velocity.y >= player.low_grav_apex_threshold:
			player.apply_gravity(player.jump_apex_gravity)
		else:
			player.apply_gravity(player.jump_gravity)
	player.clamp_fall_speed()
	
	if is_zero_approx(player.input_direction.x):
		if !is_zero_approx(player.velocity.x):
			player.apply_friction()
	else:
		player.apply_acceleration()
		player.check_direction_facing()
	player.apply_movement()
	
	check_air_transitions()
	
	if player.dash_input and player.dash_cooldown.is_stopped():
		state_machine.transition_to("Dash")
		player.fall_timer.stop()
		return
	
	if player.velocity.y > 0:
		state_machine.transition_to("Fall", {from_jump = true})
