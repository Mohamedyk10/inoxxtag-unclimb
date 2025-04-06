extends Node2D

var player

func _ready():
	hide_game_over()
	show_hud()
	player = $"../Player"

func _process(delta):
	if not player.game_started:
		if Input.is_action_just_pressed("JUMP") and not player.is_timed_out:
			print("START")
			player.start()

func show_hud():
	$Title_screen.show()

func hide_hud():
	$Title_screen.hide()

func show_game_over():
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play("the_game")

func hide_game_over():
	$AnimatedSprite2D.hide()
