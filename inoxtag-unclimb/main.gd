extends Node2D

func _ready():
	$HUD.set_process(false)
	$Player.set_process(false)
	$Player.hide()
	$Levels/Labels/Label.hide()
	$Levels/Labels/Label2.hide()
	pass

func _process(delta: float) -> void:
	if $HUD.game_started:
		$Levels/Labels/Label.show()
		$Levels/Labels/Label2.show()
	pass
	
func _on_intro_intro_finish() -> void:
	$Intro.hide()
	$HUD.set_process(true)
	$Player.show()
	$Player.set_process(true)
	pass # Replace with function body.
