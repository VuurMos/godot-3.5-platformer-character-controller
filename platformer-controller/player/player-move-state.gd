# Move State
extends PlayerState

func enter(msg := {}) -> void:
	pass

func update(delta: float) -> void:
	# Player ground movement
	if is_zero_approx(player.input_direction):
		if !is_zero_approx(player.velocity.x):
			player.apply_friction(player.friction * delta)
	else:
		player.apply_acceleration(player.input_direction * player.acceleration * delta)
		player.check_direction_facing()
	
	player.apply_movement()
	
	# If the player is not grounded, transition to the air state
	if !player.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	# If the conditions for jump are valid, transition to the air state (jump)
	if !player.jump_buffer.is_stopped():
		state_machine.transition_to("Air", {jump = true})
	
	# If player x velocity == 0, transition to the idle state
	if is_zero_approx(player.velocity.x):
		state_machine.transition_to("Idle")
