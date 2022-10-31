# Air State
extends PlayerAirState


func enter(msg := {}) -> void:
	#Add initial jump force
	player.velocity.y = 0
	player.add_jump_velocity()
	print("jump state")


func update(delta: float) -> void:
		# Jump cancel (variable jump height)
	if !player.jump_input:
		player.apply_fall_gravity()
	else:
		if player.velocity.y >= player.low_grav_apex_threshold:
			player.apply_apex_gravity()
		else:
			player.apply_jump_gravity()
	
	player.apply_movement()
	
	check_air_transitions()
	
	# If y velocity becomes positive, transition to fall state
	if player.velocity.y > 0:
		state_machine.transition_to("Fall")
