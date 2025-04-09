extends Area2D

signal change

@export var is_pressed:bool = false
var link_code

func _ready() -> void:
	add_to_group("levers")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_pressed = true
		change.emit()

func _on_child_entered_tree(node: Node) -> void:
	var childrenName = node.name
	if len(childrenName) == 1:
		link_code = int(childrenName)
