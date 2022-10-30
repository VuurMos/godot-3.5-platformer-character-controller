class_name PlayerGroundState
extends PlayerState


func enter(msg := {}) -> void:
	player.allow_double_jump = true


func update(delta: float) -> void:
	player.velocity.y = 0
	
	if !player.is_on_floor():
		state_machine.transition_to("Fall", {from_ground = true})
	
	if !player.jump_buffer.is_stopped():
		state_machine.transition_to("Jump")
