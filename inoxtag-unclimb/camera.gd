extends Camera2D

var player

func _ready() -> void:
	player = $"../Player"

func _process(delta: float) -> void:
	if player.game_started:
		position = lerp(position, player.position, 0.5)
	else:
		position = player.position
