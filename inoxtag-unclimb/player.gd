extends CharacterBody2D

const HORIZONTAL_SPEED = 500
const VERTICAL_SPEED = 200
const JUMP_INITIAL_SPEED = -1500
const ZIPLINE_SPEED = 1000

const GRAVITY_ACCELERATION = 7500

var is_jumping = false
var vertical_speed = 0

var zip_line_coefs = null


func _ready() -> void:
	$Animation.play("stop")
	set_floor_stop_on_slope_enabled(false)


func f(x: float, coefs: Vector4) -> float:
	var A = coefs[0]
	var B = coefs[1]
	var C = coefs[2]
	var D = coefs[3]
	return (D - B) / (C - A) * x + B - (D - B) / (C - A) * A


func _process(delta) -> void:
	velocity = Vector2(0, 0)
	
	if zip_line_coefs != null and not Input.is_action_pressed("JUMP"):
		var x = global_position[0]
		var y = global_position[1]
		print("-------")
		print(x, " ", y)
		x = x + ZIPLINE_SPEED * delta
		y = f(x, zip_line_coefs)
		print(x, " ", y)
		global_position = Vector2(x, y)
		move_and_slide()
		return

	if is_on_floor():
		vertical_speed = 0

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
	if Input.is_action_pressed("JUMP"):
		if is_jumping:
			vertical_speed += 0.5 * GRAVITY_ACCELERATION * delta
		else:
			if is_on_floor() or is_on_wall() or zip_line_coefs != null:
				is_jumping = true
				vertical_speed = JUMP_INITIAL_SPEED
	else:
		is_jumping = false

	if not is_jumping and not uses_ice_axe:
		vertical_speed += GRAVITY_ACCELERATION * delta

	if Input.is_action_pressed("UP") and uses_ice_axe:
		vertical_speed -= VERTICAL_SPEED
	if Input.is_action_pressed("DOWN") and uses_ice_axe:
		vertical_speed += VERTICAL_SPEED

	velocity[1] = vertical_speed
	move_and_slide()
