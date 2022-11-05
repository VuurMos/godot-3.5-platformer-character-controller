# Air State
class_name PlayerAirState
extends PlayerState


func check_air_transitions():
	# If grounded, transition to move or idle states
	if player.is_on_floor():
		state_machine.transition_to("Land")
