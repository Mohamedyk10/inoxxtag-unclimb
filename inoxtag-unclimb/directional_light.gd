extends DirectionalLight2D

var player

func _ready() -> void:
	player = $"../Player"

func _process(delta: float) -> void:
	if player.game_started:
		show()
	else:
		hide()
