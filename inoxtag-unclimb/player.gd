extends RigidBody2D

@export var impulse_strenght = 1_000
@export var jump_impulse_strenght = 20_000



var is_jumping = false

func is_on_floor():
	set_contact_monitor(true)
	print(get_colliding_bodies())
	for body in get_colliding_bodies():
		print(body.name)
		if "Mountain" in body.name:
			return true
	return false

func _process(delta):
	var int = 2  # Pour Allan
	var impulse = Vector2(0, 0)
	var up = Input.is_action_pressed("JUMP")
	var left = Input.is_action_pressed("LEFT")
	var right = Input.is_action_pressed("RIGHT")
	if up and not is_jumping:
		is_jumping = true
		impulse[1] = -jump_impulse_strenght
	else:
		if is_on_floor():
			is_jumping = false
	if left and not right:
		impulse[0] = -impulse_strenght
	if right and not left:
		impulse[0] = impulse_strenght
	apply_impulse(impulse)
