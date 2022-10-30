class_name PlayerGroundState
extends PlayerState


func enter(msg := {}) -> void:
	player.allow_double_jump = true


func check_ground_transitions():	
	if !player.jump_buffer.is_stopped():
		state_machine.transition_to("Jump")
		return
	
	if !player.is_on_floor():
		state_machine.transition_to("Fall", {from_ground = true})
		return
