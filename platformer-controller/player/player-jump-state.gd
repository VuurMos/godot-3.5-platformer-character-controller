# Air State
extends PlayerState

func enter(msg := {}) -> void:
	#Add initial jump force
	player.add_jump_velocity()


func update(delta: float) -> void:
#	# Double jump check
#	if !player.jump_buffer.is_stopped() and player.allow_double_jump:
#		player.allow_double_jump = false
#		state_machine.transition_to("Jump")
	
#	# Jump cancel (variable jump height)
#	# Note: can also check a y velocity for minimum jump before cancelling
	if !player.jump_input:
		player.apply_fall_gravity()
		print("jump cancelled")
	else:
		player.apply_jump_gravity()
		print("full jump")
	
	# Player air movement
	player.apply_smooth_movement()
	
	# If y velocity becomes positive, transition to fall state
	if player.velocity.y > 0:
		state_machine.transition_to("Fall")
	
	# If grounded, transition to move or idle states
	if player.is_on_floor():
		if is_zero_approx(player.velocity.x):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Move")
