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
	
	if event.is_action_pressed("dash"):
		player.dash_input = true
	
	if event.is_action_released("dash"):
		player.dash_input = false


func update(_delta: float) -> void:
	player.input_direction = _get_input_direction()
	print(state_machine.state)
	print(player.velocity.x)


func physics_update(_delta: float) -> void:
	pass


func _get_input_direction():
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return input


func enter(_msg := {}) -> void:
	pass


func exit() -> void:
	pass
