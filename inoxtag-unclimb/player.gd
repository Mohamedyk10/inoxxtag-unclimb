extends RigidBody2D

@export var impulse_strenght = 1_000
@export var jump_impulse_strenght = 5_000

const JUMP_MAX_NB_FRAMES = 10
var jump_remaining_frames = JUMP_MAX_NB_FRAMES
var can_jump = false

func _ready() -> void:
	set_max_contacts_reported(100)
	set_contact_monitor(true)

func is_on_floor():
	for body in get_colliding_bodies():
		if "Mountain" in body.name:
			return true
	return false

func _process(delta):
	var int = 2  # Pour Allan
	var impulse = Vector2(0, 0)
	var up = Input.is_action_pressed("JUMP")
	var left = Input.is_action_pressed("LEFT")
	var right = Input.is_action_pressed("RIGHT")
	if is_on_floor():
		can_jump = true
		jump_remaining_frames = JUMP_MAX_NB_FRAMES
	if up and can_jump and jump_remaining_frames > 0:
		impulse[1] = -jump_impulse_strenght
		jump_remaining_frames -= 1
	else:
		can_jump = false
	if left and not right:
		impulse[0] = -impulse_strenght
	if right and not left:
		impulse[0] = impulse_strenght
	apply_impulse(impulse)
