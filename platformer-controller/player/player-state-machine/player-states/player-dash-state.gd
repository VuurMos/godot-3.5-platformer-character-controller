# Dash state
extends PlayerState


func enter(msg := {}) -> void:
	player.velocity.y = 0
	player.add_dash_velocity()
	player.dash_timer.start()

func physics_update(delta: float) -> void:
	player.apply_fall_gravity()
	player.apply_movement()
	
	if player.dash_timer.is_stopped():
		if !player.is_on_floor():
			state_machine.transition_to("Fall", {from_ground = true})
			return
		
		if player.is_on_floor():
			state_machine.transition_to("Land")
