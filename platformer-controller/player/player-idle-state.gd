# Idle State
extends PlayerState

func enter(_msg := {}) -> void:
	owner.velocity = Vector2.ZERO

func update(delta: float) -> void:
	if !owner.is_on_floor():
		state_machine.transition_to("Air")
		return
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {jump = true})
	elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		state_machine.transition_to("Run")
