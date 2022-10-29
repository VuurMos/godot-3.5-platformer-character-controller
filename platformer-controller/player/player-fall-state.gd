# Fall State
extends PlayerAirState


func enter(msg := {}) -> void:
	# Start coyote time
	if msg.has("from_ground"):
		player.coyote_timer.start()


func update(delta: float) -> void:
	# Jump check with coyote time
	if !player.jump_buffer.is_stopped() and !player.coyote_timer.is_stopped():
		state_machine.transition_to("Jump")
	
	.update(delta)
	
	player.apply_fall_gravity()
