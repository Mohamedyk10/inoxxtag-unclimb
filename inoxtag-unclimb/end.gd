extends Control

var speed = 70
var end_credits = false

func _ready():
	end_credits = false
	pass	

func _process(delta: float) -> void:
	var scroll_speed = speed*delta
	if end_credits:
		if $Logo.global_position.x<150:
			$Logo.global_position.x += 1.1*scroll_speed 
		if $Logo2.global_position.x>800:
			$Logo2.global_position.x -= 3*scroll_speed
	else:
		$VBoxContainer.global_position.y -= 2*scroll_speed
		var size = $VBoxContainer.size
		if $VBoxContainer.global_position.y + size.y < 0:
			end_credits = true
	pass
