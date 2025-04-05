extends CharacterBody2D

const HORIZONTAL_SPEED = 500
const VERTICAL_SPEED = 200
const JUMP_INITIAL_SPEED = -1500

const GRAVITY_ACCELERATION = 7500

var is_jumping = false
var vertical_speed = 0

func _ready() -> void:
	pass

func _process(delta) -> void:
	velocity = Vector2(0, 0)
	if is_on_floor():
		vertical_speed = 0
	vertical_speed += GRAVITY_ACCELERATION * delta
	if Input.is_action_pressed("JUMP"):
		if is_jumping:
			vertical_speed -= 0.5 * GRAVITY_ACCELERATION * delta  # We remove 50% of gravity if jumping
		else:
			if is_on_floor():
				is_jumping = true
				vertical_speed = JUMP_INITIAL_SPEED
	else:
		is_jumping = false
	var uses_ice_axe = false
	if Input.is_action_pressed("LEFT"):
		velocity[0] += -HORIZONTAL_SPEED
		if is_on_wall():
			uses_ice_axe = true
	if Input.is_action_pressed("RIGHT"):
		velocity[0] += HORIZONTAL_SPEED
		if is_on_wall():
			uses_ice_axe = true
	if uses_ice_axe:
		vertical_speed = 0
	if Input.is_action_pressed("UP") and uses_ice_axe:
		vertical_speed -= VERTICAL_SPEED
	if Input.is_action_pressed("DOWN") and uses_ice_axe:
		vertical_speed += VERTICAL_SPEED
	velocity[1] = vertical_speed
	move_and_slide()
