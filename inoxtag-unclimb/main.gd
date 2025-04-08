extends Node2D
var checkpoint1 = false
var checkpoint2 = false
var checkpoint3 = false
var checkpoint4 = false

func _ready():
	$HUD.set_process(false)
	$Player.set_process(false)
	$Player.hide()
	$End.set_process(false)
	$End.hide()
	$Levels.hide_labels()
	pass

func _process(delta: float) -> void:
	if $Player.game_started:
		$Levels.show_labels()
		if $Player.global_position.x>=$Levels/Checkpoint.global_position.x:
			checkpoint1 = true
		if $Player.global_position.x>=$Levels/Checkpoint2.global_position.x:
			checkpoint2 = true
		if $Player.global_position.x>=$Levels/Checkpoint3.global_position.x:
			checkpoint3 = true
		if $Player.global_position.x>=$Levels/Checkpoint4.global_position.x:
			checkpoint4 = true
		
		if checkpoint4:
			$Player.START_COORDINATES = Vector2($Levels/Checkpoint4.global_position.x,$Levels/Checkpoint4.global_position.y-48)
		elif checkpoint3:
			$Player.START_COORDINATES = Vector2($Levels/Checkpoint3.global_position.x,$Levels/Checkpoint3.global_position.y-48)
		elif checkpoint2:
			$Player.START_COORDINATES = Vector2($Levels/Checkpoint2.global_position.x,$Levels/Checkpoint2.global_position.y-48)
		elif checkpoint1:
			$Player.START_COORDINATES = Vector2($Levels/Checkpoint.global_position.x,$Levels/Checkpoint.global_position.y-48)
		
	else:
		$Levels.hide_labels()
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


func _on_player_end_game() -> void:
	$End.set_process(true)
	$End.show()
	$Player.global_position = Vector2(0,0)
	$Player.game_started = false
	$Player.hide()
	$Player.set_process(false)
	
	#$Levels.set_process(false)
	$Levels.hide_labels()
	
	pass # Replace with function body.
