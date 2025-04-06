extends Area2D

func _ready():
	add_to_group("ropes")
	$Sprite2D.hide()

var is_player_touching_the_rope: bool = false
var rope_code = 1
signal can_climb

func _on_body_entered(body):
	is_player_touching_the_rope = true
	can_climb.emit()

func _on_body_exited(body):
	is_player_touching_the_rope = false

func _on_lever_change() -> void:
	for lever in get_tree().get_nodes_in_group("levers"):
		if lever.link_code == rope_code:
			$Sprite2D.show()
			$CollisionShape2D.set_deferred("disabled", false)
