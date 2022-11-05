# Move State
extends PlayerGroundState


func enter(msg := {}) -> void:
	.enter(msg)


func physics_update(delta: float) -> void:
	ground_movement()
	
	if is_zero_approx(player.input_direction.x):
		state_machine.transition_to("Idle")
	
	check_ground_transitions()
