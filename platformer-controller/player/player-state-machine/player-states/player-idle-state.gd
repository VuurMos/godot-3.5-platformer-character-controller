# Idle State
extends PlayerGroundState


func physics_update(delta: float) -> void:
	ground_movement()
	
	if !is_zero_approx(player.input_direction.x):
		state_machine.transition_to("Move")
	
	check_ground_transitions()
