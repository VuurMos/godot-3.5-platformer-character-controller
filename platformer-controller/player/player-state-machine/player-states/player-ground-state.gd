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
	
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")
		return
