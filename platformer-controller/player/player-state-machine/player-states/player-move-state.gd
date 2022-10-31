# Move State
extends PlayerGroundState


func enter(msg := {}) -> void:
	.enter(msg)


func physics_update(delta: float) -> void:
	# Need to apply gravity: there is a y velocity "bump" when moving = fall state transition
	player.apply_fall_gravity()
	player.clamp_fall_speed()
	player.apply_movement()
	
	# If player x velocity == 0, transition to the idle state
	if abs(player.velocity.x) < 0.01:
		player.velocity.x = 0
		state_machine.transition_to("Idle")
	
	check_ground_transitions()
