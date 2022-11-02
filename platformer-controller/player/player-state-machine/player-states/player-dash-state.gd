# Dash state
extends PlayerState

var dash_direction := Vector2.ZERO
var current_dash_time := 0.0
var dash_duration := 0.1

func enter(msg := {}) -> void:
	player.velocity.y = 0.0
	dash_direction = player.input_direction.normalized()
	player.dashing = true
	current_dash_time = 0.0

func physics_update(delta: float) -> void:
	if player.dash_input:
		current_dash_time += delta
		
		var dash_progress = current_dash_time / dash_duration
		var dash_velocity = 1 - pow(2, -10 * dash_progress)
		
		player.add_dash_velocity(dash_direction, dash_velocity)

		player.apply_movement()
	
	
	if current_dash_time >= dash_duration or !player.dash_input:
		if !player.is_on_floor():
			state_machine.transition_to("Fall", {from_ground = true})
			return

		if player.is_on_floor():
			state_machine.transition_to("Land")

func exit() -> void:
	player.dashing = false
	player.dash_input = false
