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
	
#	# Double jump check
#	if !player.jump_buffer.is_stopped() and player.allow_double_jump:
#		player.allow_double_jump = false
#		state_machine.transition_to("Jump")

	# Player air movement
	if !is_zero_approx(player.input_direction):
		player.check_direction_facing()
	player.apply_fall_gravity()
	player.apply_movement()
	
	# If grounded, transition to move or idle states
	if player.is_on_floor():
		if is_zero_approx(player.velocity.x):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Move")
