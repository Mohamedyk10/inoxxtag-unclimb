extends Node2D

var player
@export var game_started = false

func _ready():
	game_started=false
	hide_game_over()
	show_hud()
	player = $"../Player"

func _process(delta):
	if not player.game_started:
		if Input.is_action_just_pressed("JUMP") and not player.is_timed_out:
			print("START")
			player.start()
			game_started = true

func show_hud():
	game_started=false
	$Title_screen.show()

func hide_hud():
	$"../CanvasLayer/SpeedRun".set_process(true)
	$"../CanvasLayer/SpeedRun".show()
	$Title_screen.hide()

func show_game_over():
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play("the_game")

func hide_game_over():
	$AnimatedSprite2D.hide()
