# Move State
extends PlayerGroundState


func enter(msg := {}) -> void:
	.enter(msg)


func physics_update(delta: float) -> void:
	ground_movement()
	
	# TODO: If running at a wall (x vel = 0) then will flip between idle and move
	if is_zero_approx(player.input_direction.x):
		state_machine.transition_to("Idle")
	
	check_ground_transitions()
