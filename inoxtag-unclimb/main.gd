extends Node2D

func _ready():
	$HUD.set_process(false)
	$Player.set_process(false)
	$Player.hide()
	pass


func _on_intro_intro_finish() -> void:
	$Intro.hide()
	$HUD.set_process(true)
	$Player.show()
	$Player.set_process(true)
	pass # Replace with function body.
