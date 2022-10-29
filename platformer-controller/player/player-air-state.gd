# Air State
class_name PlayerAirState
extends PlayerState


func update(delta: float) -> void:
#	# Double jump check
	if !player.jump_buffer.is_stopped() and player.allow_double_jump:
		player.allow_double_jump = false
		state_machine.transition_to("Jump")
	
	# Player air movement
	player.apply_movement()
	
	# If grounded, transition to move or idle states
	if player.is_on_floor():
		if is_zero_approx(player.velocity.x):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Move")