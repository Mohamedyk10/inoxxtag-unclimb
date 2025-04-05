extends Node2D
var game_starts = false

func _ready() -> void:
	$Title_screen.show()
	game_starts=false
	pass

func _process(delta):
	if not game_starts:
		if Input.is_action_just_pressed("JUMP"):
			$Title_screen.hide()
	pass
