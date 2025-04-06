extends Area2D

var rope_code

func _ready():
	add_to_group("ropes")
	$Sprite2D.hide()

var is_player_touching_the_rope: bool = false
signal can_climb

func _on_body_entered(_body):
	is_player_touching_the_rope = true
	can_climb.emit()
	body.current_rope = self

func _on_body_exited(_body):
	is_player_touching_the_rope = false
	body.current_rope = null

func _on_lever_change() -> void:
	for lever in get_tree().get_nodes_in_group("levers"):
		if lever.link_code == rope_code:
			$Sprite2D.show()
			$CollisionShape2D.set_deferred("disabled", false)

func _on_child_entered_tree(node: Node) -> void:
	var childrenName = node.name
	if len(childrenName) == 1:
		rope_code = int(childrenName)
