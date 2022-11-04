# Dash state
extends PlayerState

var dash_direction := Vector2.ZERO
var current_dash_time := 0.0
var dash_duration := 0.3
var minimum_dash_progress := 0.5


func enter(msg := {}) -> void:
	player.velocity.y = 0.0
	dash_direction = player.input_direction.normalized()
	player.dashing = true
	current_dash_time = 0.0

func physics_update(delta: float) -> void:
	if player.is_on_floor():
		player.velocity.y = 0
	
	current_dash_time += delta
	var dash_progress = current_dash_time / dash_duration
	
	print("dash progress: " + str(dash_progress))
	
	#Apply the dash velocity
	if player.dash_input or dash_progress < minimum_dash_progress:
		var dash_velocity = 1 - pow(2, -10 * dash_progress)
		
		player.add_dash_velocity(dash_direction, dash_velocity)
		player.apply_movement()
	
	#Leave the dash state
	if current_dash_time >= dash_duration or !player.dash_input and dash_progress > minimum_dash_progress:
		if !player.is_on_floor():
			state_machine.transition_to("Fall", {from_ground = true})
			return

		if player.is_on_floor():
			if !is_zero_approx(player.input_direction.x):
				state_machine.transition_to("Move")
			else:
				player.velocity.x = 0
				state_machine.transition_to("Idle")

func exit() -> void:
	player.dashing = false
	player.dash_input = false
