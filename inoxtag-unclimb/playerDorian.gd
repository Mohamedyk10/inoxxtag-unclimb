extends CharacterBody2D

const HORIZONTAL_SPEED = 500
const VERTICAL_SPEED = 200
const JUMP_INITIAL_SPEED = -1500

const GRAVITY_ACCELERATION = 7500

var is_jumping = false
var vertical_speed = 0
var horizontal_speed = 0

var is_in_zip_line_area = false

var uses_grappling_hook=false
var len_grap=0.0
var current_hook=null
var aimed_hook=null
var acc_rot = 0
var rot_speed=0
var er = Vector2(0,0)

func _ready() -> void:
	$Animation.play("stop")
	set_floor_stop_on_slope_enabled(false)

func _process(delta) -> void:
	
	
	##Grappling hook
	
	if Input.is_action_just_pressed("GRAPPLING_HOOK"):
		if uses_grappling_hook==false:
			if aimed_hook!=null:	
				velocity=Vector2(0,0)
				uses_grappling_hook=true
				current_hook=aimed_hook
				len_grap=position.distance_to(current_hook.position)
				
				var diff=position-current_hook.position
				er=diff.normalized()
				var eo=er.orthogonal()
				rot_speed=10*velocity.dot(eo)
				acc_rot = 0
		else:
			uses_grappling_hook=false
			
	if Input.is_action_just_pressed("JUMP") or is_on_ceiling() or is_on_floor() or is_on_wall():
		uses_grappling_hook=false
	
	velocity=Vector2(0,0)
	if uses_grappling_hook:
	
		var theta=er.angle()+PI/2
		if theta<-PI:
			theta+=2*PI
		if theta>=PI:
			theta-=2*PI
		
		acc_rot=sin(theta)
		print(acc_rot)
		rot_speed+=10*acc_rot*delta
		er=er.rotated(rot_speed*delta)
		
		
		set_position(current_hook.get_position() + len_grap*er)
		
		vertical_speed=1.5*JUMP_INITIAL_SPEED*abs(sin(theta))

		
		
		
		
		
		

	else:
		horizontal_speed=0

		if is_on_floor():
			vertical_speed = 0
		

		var uses_ice_axe = false

		if Input.is_action_pressed("LEFT"):
			horizontal_speed -= HORIZONTAL_SPEED
			if is_on_wall():
				uses_ice_axe = true
		if Input.is_action_pressed("RIGHT"):
			horizontal_speed += HORIZONTAL_SPEED
			if is_on_wall():
				uses_ice_axe = true

		if uses_ice_axe:
			vertical_speed = 0

		if Input.is_action_pressed("JUMP"):
			if is_jumping:
				vertical_speed += 0.5 * GRAVITY_ACCELERATION * delta
			else:
				if is_on_floor() or is_on_wall() or uses_grappling_hook:
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
	
		velocity[0] = horizontal_speed
		velocity[1] = vertical_speed
		move_and_slide()

func _on_grappling_range_body_entered(body: Node2D) -> void:
	if body.get_parent().name=="Hooks": 
		aimed_hook=body
	
func _on_grappling_range_body_exited(body: Node2D) -> void:
	if body==aimed_hook: 
		aimed_hook=null
		


		
		
