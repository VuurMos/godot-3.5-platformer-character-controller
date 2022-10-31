# Fall State
extends PlayerAirState


func enter(msg := {}) -> void:
	# Start coyote time
	if msg.has("from_ground"):
		player.coyote_timer.start()
	
	player.fall_timer.start()


func physics_update(delta: float) -> void:
	player.apply_fall_gravity()
	player.clamp_fall_speed()
	player.apply_movement()
	
	# Jump check - needs to be before double jump check!
	if !player.jump_buffer.is_stopped() and !player.coyote_timer.is_stopped():
		state_machine.transition_to("Jump")
	
	check_air_transitions()
