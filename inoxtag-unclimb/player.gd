extends CharacterBody2D

const HORIZONTAL_SPEED = 500
const VERTICAL_SPEED = 200

const JUMP_INITIAL_SPEED = -1300
const ZIPLINE_SPEED = 1000

const GRAVITY_ACCELERATION = 7500

const START_COORDINATES = Vector2(250, 750)

var hud

var lantern_status = false
var is_jumping = false
var orientation = "droite"
var animation = ""
var vertical_speed = 0
var uses_ice_axe

var game_started = false
var is_timed_out = false

var zip_line_coefs = null


func _ready() -> void:
	global_position = Vector2(0, 0)
	hud = $"../HUD"
	animation = "stop"
	$Animation.play(animation)
	set_floor_stop_on_slope_enabled(false)


func game_over():
	is_timed_out = true
	game_started = false
	lantern_status = false
	zip_line_coefs = null
	await get_tree().create_timer(1).timeout
	hud.show_game_over()
	global_position = Vector2(0, 0)
	await get_tree().create_timer(5).timeout
	hud.hide_game_over()
	hud.show_hud()
	is_timed_out = false

func start():
	hud.hide_game_over()
	hud.hide_hud()
	global_position = START_COORDINATES
	game_started = true


func f(x: float, coefs: Vector4) -> float:
	var A = coefs[0]
	var B = coefs[1]
	var C = coefs[2]
	var D = coefs[3]
	return (D - B) / (C - A) * x + B - (D - B) / (C - A) * A


func _process(delta) -> void:
	if Input.is_action_pressed("RESET"):
		game_over()
		return
	if not game_started:
		return

	if Input.is_action_just_pressed("USE_LANTERN"):
		lantern_status = not(lantern_status)
	if lantern_status:
		animation = "stop_lantern"
	else:
		animation = "stop"

	if lantern_status:
		$PointLight2D.show()
	else:
		$PointLight2D.hide()

	velocity = Vector2(0, 0)
	
	if zip_line_coefs != null and not Input.is_action_pressed("JUMP") and not Input.is_action_pressed("SHIFT"):
		var x = global_position[0]
		var y = global_position[1]
		x = x + ZIPLINE_SPEED * delta
		y = f(x, zip_line_coefs)
		global_position = Vector2(x, y)
		move_and_slide()
		return

	if is_on_floor():
		vertical_speed = 0

	uses_ice_axe = false
	if is_on_wall() and Input.is_action_pressed("HOLD"):
		uses_ice_axe = true

	if Input.is_action_pressed("LEFT") and not uses_ice_axe:
		velocity[0] += -HORIZONTAL_SPEED
		orientation = "left"
		if lantern_status:
			animation = "run_right_lantern"
		else:
			animation = "run_right"
	if Input.is_action_pressed("RIGHT") and not uses_ice_axe:
		velocity[0] += HORIZONTAL_SPEED
		orientation = "right"
		if lantern_status:
			animation = "run_right_lantern"
		else :
			animation = "run_right"

	if uses_ice_axe:
		vertical_speed = 0

	if Input.is_action_pressed("JUMP"):
		if is_jumping:
			vertical_speed += 0.5 * GRAVITY_ACCELERATION * delta
			animation = "jump"
		else:
			if is_on_floor() or is_on_wall() or zip_line_coefs != null:
				is_jumping = true
				uses_ice_axe = false
				vertical_speed = JUMP_INITIAL_SPEED
				velocity[1] = vertical_speed
				animation = "jump"
	else:
		is_jumping = false

	if not is_jumping and not uses_ice_axe:
		vertical_speed += GRAVITY_ACCELERATION * delta

	if uses_ice_axe:
		animation = "climb_no_move"
		if orientation == "right":
			velocity[0] += 1
		else:
			velocity[0] -= 1
		if Input.is_action_pressed("UP") and uses_ice_axe:
			vertical_speed -= VERTICAL_SPEED
			animation = "climb_up_or_down"
		if Input.is_action_pressed("DOWN") and uses_ice_axe:
			vertical_speed += VERTICAL_SPEED
			animation = "climb_up_or_down"
	if orientation == "right":
		$Animation.flip_h = false
		$Animation.play(animation)
	else:
		$Animation.flip_h = true
		$Animation.play(animation)
	velocity[1] = vertical_speed

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	game_over()
