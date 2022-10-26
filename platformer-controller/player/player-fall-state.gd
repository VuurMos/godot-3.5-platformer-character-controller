# Fall State
extends PlayerState

func enter(msg := {}) -> void:
	# Start coyote time
	if msg.has("from_ground"):
		player.coyote_timer.start()


func update(delta: float) -> void:
	# Coyote jump check
	if !player.jump_buffer.is_stopped() and !player.coyote_timer.is_stopped():
		state_machine.transition_to("Jump")
	
	# Air jump check
	if !player.jump_buffer.is_stopped() and player.current_air_jumps > 0:
		player.current_air_jumps -= 1
		state_machine.transition_to("Jump")

	# Player air movement
	if is_zero_approx(player.input_direction):
		if !is_zero_approx(player.velocity.x):
			player.apply_friction(player.friction * delta)
	else:
		player.apply_acceleration(player.input_direction * player.acceleration * delta)
		player.check_direction_facing()
	
	player.apply_gravity(player.strong_gravity)
	player.apply_movement()
	player.clamp_fall_velocity()
	
	# If grounded, transition to move or idle states
	if player.is_on_floor():
		if is_zero_approx(player.velocity.x):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Move")
