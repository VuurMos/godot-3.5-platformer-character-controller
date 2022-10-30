class_name PlayerState
extends Node

var state_machine = null
var player = null


func _ready() -> void:
	yield(owner, "ready")
	player = owner as PlatformController
	assert(player != null)


func set_state_machine(new_state_machine):
	state_machine = new_state_machine


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func enter(_msg := {}) -> void:
	pass


func exit() -> void:
	pass
