class_name PlayerGroundState
extends PlayerState


func enter(msg := {}) -> void:
	pass


func check_ground_transitions():	
	if !player.jump_buffer.is_stopped():
		state_machine.transition_to("Jump")
		return
	
	if !player.is_on_floor():
		state_machine.transition_to("Fall", {from_ground = true})
		return
	
	if player.dash_input and player.dash_cooldown.is_stopped():
		state_machine.transition_to("Dash")
		return


func ground_movement():
	player.apply_gravity(player.fall_gravity)
	player.clamp_fall_speed()
	
	if is_zero_approx(player.input_direction.x):
		if !is_zero_approx(player.velocity.x):
			player.apply_friction()
	else:
		player.apply_acceleration()
		player.check_direction_facing()
	
	player.apply_movement()
