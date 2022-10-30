# Land state
extends PlayerGroundState

func enter(msg := {}) -> void:
	.enter(msg)
	
	if player.fall_timer.is_stopped():
		Events.emit_signal("cam_noise_screen_shaked", 0.3)

func update(delta: float) -> void:
	.update(delta)
	
	if is_zero_approx(player.velocity.x):
		state_machine.transition_to("Idle")
	else:
		state_machine.transition_to("Move")
