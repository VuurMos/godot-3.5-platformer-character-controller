# Air State
class_name PlayerAirState
extends PlayerState


func check_air_transitions():
	if player.is_on_floor():
		state_machine.transition_to("Land")
