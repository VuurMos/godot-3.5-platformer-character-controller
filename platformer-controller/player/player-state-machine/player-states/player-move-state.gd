# Move State
extends PlayerGroundState


func enter(msg := {}) -> void:
	.enter(msg)


func physics_update(delta: float) -> void:
	# Need to apply gravity: there is a y velocity "bump" when moving = fall state transition
	player.apply_gravity(player.fall_gravity)
	player.clamp_fall_speed()
	
	if is_zero_approx(player.input_direction.x):
		if !is_zero_approx(player.velocity.x):
			player.apply_friction()
	else:
		player.apply_acceleration()
		player.check_direction_facing()
	
	player.apply_movement()
	
	# TODO: If running at a wall (x vel = 0) then will flip between idle and move
	if abs(player.velocity.x) < 0.01:
		player.velocity.x = 0
		state_machine.transition_to("Idle")
	
	check_ground_transitions()
