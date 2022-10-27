# Move State
extends PlayerState

func enter(msg := {}) -> void:
	player.current_air_jumps = player.max_air_jumps


func update(delta: float) -> void:
	if !is_zero_approx(player.input_direction):
		player.check_direction_facing()
	player.velocity.y = 0
	player.apply_movement()
	
	# If the player is not grounded, transition to the fall state
	if !player.is_on_floor():
		state_machine.transition_to("Fall", {from_ground = true})
		return
	
	# If the conditions for jump are valid, transition to the jump state
	if !player.jump_buffer.is_stopped():
		state_machine.transition_to("Jump")
	
	# If player x velocity == 0, transition to the idle state
	if is_zero_approx(player.velocity.x):
		state_machine.transition_to("Idle")
