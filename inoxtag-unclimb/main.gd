extends Node2D
var checkpoint1 = false
var checkpoint2 = false
var checkpoint3 = false
func _ready():
	$HUD.set_process(false)
	$Player.set_process(false)
	$Player.hide()
	$Levels/Labels/Label.hide()
	$Levels/Labels/Label2.hide()
	$Levels/Labels/Label3.hide()
	pass

func _process(delta: float) -> void:
	if $Player.game_started:
		$Levels/Labels/Label.show()
		$Levels/Labels/Label2.show()
		$Levels/Labels/Label3.show()
		if $Player.global_position.x>=$Levels/Checkpoint.global_position.x:
			checkpoint1 = true
		if $Player.global_position.x>=$Levels/Checkpoint2.global_position.x:
			checkpoint2 = true
		if $Player.global_position.x>=$Levels/Checkpoint3.global_position.x:
			checkpoint3 = true
		
		if checkpoint3:
			$Player.START_COORDINATES = Vector2($Levels/Checkpoint3.global_position.x,$Levels/Checkpoint3.global_position.y-48)
		elif checkpoint2:
			$Player.START_COORDINATES = Vector2($Levels/Checkpoint2.global_position.x,$Levels/Checkpoint2.global_position.y-48)
		elif checkpoint1:
			$Player.START_COORDINATES = Vector2($Levels/Checkpoint.global_position.x,$Levels/Checkpoint.global_position.y-48)
		
	else:
		$Levels/Labels/Label.hide()
		$Levels/Labels/Label2.hide()
		$Levels/Labels/Label3.hide()
		checkpoint1 = false
		checkpoint2 = false
		checkpoint3 = false
	pass
	
func _on_intro_intro_finish() -> void:
	$Intro.hide()
	$HUD.set_process(true)
	$Player.show()
	$Player.set_process(true)
	pass # Replace with function body.
