# Move State
extends PlayerGroundState


func enter(msg := {}) -> void:
	.enter(msg)


func update(delta: float) -> void:
	# Need to apply gravity: there is a y velocity "bump" when moving = fall state transition
	player.apply_fall_gravity()
	player.apply_movement()
	
	check_ground_transitions()
	
	# If player x velocity == 0, transition to the idle state
	if is_zero_approx(player.velocity.x):
		state_machine.transition_to("Idle")
