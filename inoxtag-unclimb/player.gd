extends CharacterBody2D

const HORIZONTAL_SPEED = 500
const JUMP_SPEED = -1500

const GRAVITY_G = 7500

var is_jumping = false
var vertical_speed = 0

func _ready() -> void:
	pass

func _process(delta) -> void:
	velocity = Vector2(0, vertical_speed)
	var up = Input.is_action_pressed("JUMP")
	var left = Input.is_action_pressed("LEFT")
	var right = Input.is_action_pressed("RIGHT")
	if is_on_floor():
		vertical_speed = 0
	if up:
		if is_jumping:
			vertical_speed += 0.5 * GRAVITY_G * delta
		else:
			if is_on_floor():
				is_jumping = true
				vertical_speed = JUMP_SPEED
	else:
		is_jumping = false
		vertical_speed += GRAVITY_G * delta
	velocity[1] = vertical_speed
	if left:
		velocity[0] += -HORIZONTAL_SPEED
	if right:
		velocity[0] += HORIZONTAL_SPEED
	move_and_slide()
