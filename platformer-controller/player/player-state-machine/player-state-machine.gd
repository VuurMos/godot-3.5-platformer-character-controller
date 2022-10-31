class_name PlayerStateMachine
extends Node

signal transitioned(state_name)

export var initial_state := NodePath()

onready var state: PlayerState = get_node(initial_state)


func _ready() -> void:
	yield(owner, "ready")
	for child in get_children():
		child.set_state_machine(self)
	state.enter()


func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)


func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		return
	
	state.exit()
	# TODO: swap node search for direct node paths
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
	print(state.name)
