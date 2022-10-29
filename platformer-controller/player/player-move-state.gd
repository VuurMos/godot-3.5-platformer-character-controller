# Move State
extends PlayerGroundState


func enter(msg := {}) -> void:
	.enter(msg)


func update(delta: float) -> void:
	.update(delta)
	
	# If player x velocity == 0, transition to the idle state
	if is_zero_approx(player.velocity.x):
		state_machine.transition_to("Idle")
	
	player.apply_movement()
