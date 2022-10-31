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


func handle_input(event: InputEvent) -> void:
	# Check if jump input has been pressed (recently with buffer)
	if event.is_action_pressed("jump"):
		player.jump_input = true
		player.jump_buffer.start()
	
	# Check if should cancel jump early
	if event.is_action_released("jump"):
		player.jump_input = false


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	player.input_direction = _get_input_direction()


func _get_input_direction():
	var input = 0.0
	input = Input.get_action_strength("right") - Input.get_action_strength("left")
	return input


func enter(_msg := {}) -> void:
	pass


func exit() -> void:
	pass
