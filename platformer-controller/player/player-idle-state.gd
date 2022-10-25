# Idle State
extends PlayerState

func enter(msg := {}) -> void:
	player.velocity = Vector2.ZERO

func update(delta: float) -> void:
	# If the player is not grounded, transition to the fall state
	if !player.is_on_floor():
		state_machine.transition_to("Fall")
		return
	
	# If the conditions for jump are valid, transition to the jump state
	if !player.jump_buffer.is_stopped():
		state_machine.transition_to("Jump", {jump = true})
	
	# If player direction input or x velocity != 0, transition to the move state
	if !is_zero_approx(player.input_direction) or !is_zero_approx(player.velocity.x):
		state_machine.transition_to("Move")