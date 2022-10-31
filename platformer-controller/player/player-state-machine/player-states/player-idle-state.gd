# Idle State
extends PlayerGroundState


func enter(msg := {}) -> void:
	.enter(msg)


func physics_update(delta: float) -> void:
	# If player direction input or x velocity != 0, transition to the move state
	if !is_zero_approx(player.input_direction.x):
		state_machine.transition_to("Move")
	
	check_ground_transitions()
