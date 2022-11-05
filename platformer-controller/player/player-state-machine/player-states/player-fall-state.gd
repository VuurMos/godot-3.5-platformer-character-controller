# Fall State
extends PlayerAirState

var from_ground_fall := false

func enter(msg := {}) -> void:
	# Start coyote time
	if msg.has("from_ground"):
		player.coyote_timer.start()
		from_ground_fall = true
	else:
		from_ground_fall = false
	
	player.fall_timer.start()


func physics_update(delta: float) -> void:
	if from_ground_fall:
		player.apply_gravity(player.fall_gravity * 0.5)
	else:
		player.apply_gravity(player.fall_gravity)
	player.clamp_fall_speed()
	
	if is_zero_approx(player.input_direction.x):
		if !is_zero_approx(player.velocity.x):
			player.apply_friction()
	else:
		player.apply_acceleration()
		player.check_direction_facing()
	player.apply_movement()
	
	# Jump check - needs to be before double jump check!
	if !player.jump_buffer.is_stopped() and !player.coyote_timer.is_stopped():
		player.fall_timer.stop()
		state_machine.transition_to("Jump")
		return
	
	if player.dash_input:
		state_machine.transition_to("Dash")
		player.fall_timer.stop()
		return
	
	check_air_transitions()
