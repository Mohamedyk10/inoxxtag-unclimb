extends CharacterBody2D

const HORIZONTAL_SPEED = 500
const VERTICAL_SPEED = 200

const JUMP_INITIAL_SPEED = -1300
const ZIPLINE_SPEED = 1000

const GRAVITY_ACCELERATION = 7500

const START_COORDINATES = Vector2(250, 750)

const MAX_HEIGHT = 10.5 * 48  # <= 10 blocs

var hud

var lantern_status = false
var is_jumping = false
var orientation = "right"
var animation = ""
var vertical_speed = 0
var uses_ice_axe
var is_climbing
var highest_point

var game_started = false
var is_timed_out = false

var zip_line_coefs = null

var targeted_hook = null
var current_hook = null
var uses_grappling_hook = false
var len_grap = 0
var er = Vector2(0,0)
var rot_speed = 0
var acc_rot = 0
var hooks = {}
var rope = null
var current_rope = null

const ROPE_COOLDOWN = 12  # Frames; 2/10sec
var rope_cooldown = 0

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
	targeted_hook = null
	current_hook = null
	uses_grappling_hook = false
	rope = null
	current_rope = null
	await get_tree().create_timer(1).timeout
	global_position = Vector2(0, 0)
	hud.show_game_over()
	is_timed_out = false
	await get_tree().create_timer(3).timeout
	if not game_started:
		hud.hide_game_over()
		hud.show_hud()

func start():
	hud.hide_game_over()
	hud.hide_hud()
	global_position = START_COORDINATES
	highest_point = global_position[1]
	game_started = true


func f(x: float, coefs: Vector4) -> float:
	var A = coefs[0]
	var B = coefs[1]
	var C = coefs[2]
	var D = coefs[3]
	return (D - B) / (C - A) * x + B - (D - B) / (C - A) * A + 30


func _process(delta) -> void:
	if not game_started:
		return
	if Input.is_action_pressed("RESET"):
		game_over()
		return

	if global_position[1] < highest_point:
		highest_point = global_position[1]
	if is_on_floor() and global_position[1] - highest_point > 48:
		print("Chute: ", (global_position[1] - highest_point) / 48)
		if global_position[1] - highest_point > MAX_HEIGHT:
			game_over()
	if is_on_floor() or (is_on_wall() and Input.is_action_pressed("HOLD")) or zip_line_coefs != null or uses_grappling_hook or is_climbing:
		highest_point = global_position[1]
	if global_position[1] - highest_point > 0.3 * MAX_HEIGHT:
		$SpeedIndicatorI.show()
	else:
		$SpeedIndicatorI.hide()
	if global_position[1] - highest_point > 0.5 * MAX_HEIGHT:
		$SpeedIndicatorII.show()
	else:
		$SpeedIndicatorII.hide()
	if global_position[1] - highest_point > 0.7 * MAX_HEIGHT:
		$SpeedIndicatorIII.show()
	else:
		$SpeedIndicatorIII.hide()

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


	##Grappling hook###########################################################################
	var min=-1
	targeted_hook=null
	
	for hook in hooks.keys():
		if hooks[hook]==1:
			if min==-1 or global_position.distance_to(hook.global_position)<min:
				targeted_hook=hook
				min=global_position.distance_to(hook.global_position)
	if targeted_hook!=null:
		get_node("../Target").global_position=targeted_hook.global_position
	else:
		get_node("../Target").global_position=Vector2(-1000,-1000)
	
	if Input.is_action_just_pressed("GRAPPLING_HOOK"):
		if uses_grappling_hook==false:
			if targeted_hook!=null:
				velocity=Vector2(0,0)
				uses_grappling_hook=true
				current_hook=targeted_hook
				len_grap=global_position.distance_to(current_hook.global_position)
				
				var diff=global_position-current_hook.global_position
				er=diff.normalized()
				var eo=er.orthogonal()
				rot_speed=10*velocity.dot(eo)
				acc_rot = 0
				
				rope=current_hook.get_node("Rope")
				rope.global_position=current_hook.global_position
				rope.scale = Vector2(0.1, (len_grap-0.5)/48)
				
		else:
			if rope!=null:
				rope.global_position=Vector2(-1000,-1000)
			vertical_speed=0
			uses_grappling_hook=false
			
	if Input.is_action_just_pressed("JUMP") and uses_grappling_hook==true:
		if rope!=null:
				rope.global_position=Vector2(-1000,-1000)
		vertical_speed=1.3*JUMP_INITIAL_SPEED
		uses_grappling_hook=false
	
	velocity=Vector2(0,0)
	if uses_grappling_hook:

		var theta=er.angle()+PI/2
		if theta<-PI:
			theta+=2*PI
		if theta>=PI:
			theta-=2*PI
		
		if Input.is_action_pressed("RIGHT"):
			rot_speed-=0.01
		if Input.is_action_pressed("LEFT"):
			rot_speed+=0.01
		
		acc_rot=sin(theta)
		rot_speed+=10*acc_rot*delta
		rot_speed=min(50,max(-50,rot_speed))
		er=er.rotated(rot_speed*delta)
		
		global_position=current_hook.global_position + len_grap*er
		rope.rotation_degrees = (er.angle()-PI/2)*180/PI
		return

	if zip_line_coefs != null and not Input.is_action_pressed("JUMP") and not Input.is_action_pressed("SHIFT"):
		orientation = "right"
		var x = global_position[0]
		var y = global_position[1]
		x = x + ZIPLINE_SPEED * delta
		y = f(x, zip_line_coefs)
		vertical_speed = (y - global_position[1]) / delta
		global_position = Vector2(x, y)
		$Animation.play("zip_line")
		move_and_slide()
		return

	if is_on_floor():
		vertical_speed = 0

	uses_ice_axe = false
	if is_on_wall() and Input.is_action_pressed("HOLD"):
		uses_ice_axe = true

	if Input.is_action_pressed("LEFT") and not uses_ice_axe and not is_climbing:
		velocity[0] += -HORIZONTAL_SPEED
		orientation = "left"
		if lantern_status:
			animation = "run_right_lantern"
		else:
			animation = "run_right"
	if Input.is_action_pressed("RIGHT") and not uses_ice_axe and !is_climbing:
		velocity[0] += HORIZONTAL_SPEED
		orientation = "right"
		if lantern_status:
			animation = "run_right_lantern"
		else :
			animation = "run_right"

	if uses_ice_axe or is_climbing:
		vertical_speed = 0

	if current_rope != null and Input.is_action_pressed("HOLD"):
		if rope_cooldown > 0:
			rope_cooldown -= 1
		else:
			is_climbing = true
			global_position[0] = current_rope.global_position[0]

	if Input.is_action_pressed("JUMP"):
		if is_jumping:
			vertical_speed += 0.5 * GRAVITY_ACCELERATION * delta
			animation = "jump"
		else:
			if is_on_floor() or is_on_wall() or zip_line_coefs != null or is_climbing:
				if is_climbing:
					rope_cooldown = ROPE_COOLDOWN

				is_jumping = true
				uses_ice_axe = false
				is_climbing = false
				vertical_speed = JUMP_INITIAL_SPEED
				velocity[1] = vertical_speed
				animation = "jump"
				if orientation == "right":
					velocity[0] -= 1
				else:
					velocity[0] += 1
	else:
		is_jumping = false

	if not is_jumping and not uses_ice_axe and not is_climbing:
		vertical_speed += GRAVITY_ACCELERATION * delta
	
	if uses_ice_axe or is_climbing:
		animation = "climb_no_move"
		if uses_ice_axe:
			if orientation == "right":
				velocity[0] += 1
			else:
				velocity[0] -= 1
		if Input.is_action_pressed("UP") and Input.is_action_pressed("HOLD"):
			vertical_speed -= VERTICAL_SPEED
			animation = "climb_up_or_down"
		if Input.is_action_pressed("DOWN") and Input.is_action_pressed("HOLD"):
			vertical_speed += VERTICAL_SPEED
			animation = "climb_up_or_down"
		if Input.is_action_just_released("HOLD"):
			is_climbing = false
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

func _on_rope_can_climb() -> void:
	for rope in get_tree().get_nodes_in_group("ropes"):
		if rope.is_player_touching_the_rope:# and Input.is_action_pressed("HOLD"):
			#is_climbing = true
			current_rope = rope
			position.x = rope.position.x

func _on_grappling_area_body_entered(body: Node2D) -> void:
	if body.get_parent().name=="Hooks": 
		hooks[body]=1

	
func _on_grappling_area_body_exited(body: Node2D) -> void:
	if body.get_parent().name=="Hooks": 
		hooks[body]=0
		
		
func _on_release_grappling_area_body_entered(body: Node2D) -> void:
	if rope!=null:
		rope.global_position=Vector2(-1000,-1000)
	uses_grappling_hook=false
