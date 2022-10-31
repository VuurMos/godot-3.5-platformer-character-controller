# Dash state
extends PlayerState

var dash_direction := Vector2.ZERO

func enter(msg := {}) -> void:
	player.velocity.y = 0
	dash_direction = player.input_direction
	player.dash_timer.start()

func physics_update(delta: float) -> void:
	player.add_dash_velocity(dash_direction)
#	player.apply_fall_gravity()
	player.apply_movement()
	
	if player.dash_timer.is_stopped():
		if !player.is_on_floor():
			state_machine.transition_to("Fall", {from_ground = true})
			return
		
		if player.is_on_floor():
			state_machine.transition_to("Land")
