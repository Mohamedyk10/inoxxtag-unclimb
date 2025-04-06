extends Node2D

var player

func _ready():
	player = $"../Player"

func _process(delta):
	if not player.game_started:
		if Input.is_action_just_pressed("JUMP"):
			print("START")
			player.start()

func set_show_hud(show):
	if show:
		$Title_screen.show()
	else:
		$Title_screen.hide()
