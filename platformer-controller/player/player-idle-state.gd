# Idle State
extends PlayerGroundState


func enter(msg := {}) -> void:
	.enter(msg)
	player.velocity = Vector2.ZERO


func update(delta: float) -> void:
	.update(delta)
	
	# If player direction input or x velocity != 0, transition to the move state
	if !is_zero_approx(player.input_direction) or !is_zero_approx(player.velocity.x):
		state_machine.transition_to("Move")
