extends Area2D

signal change

var is_pressed:bool = false
@export var link_code = 1

func _ready() -> void:
	add_to_group("levers")

func _on_body_entered(body: Node2D) -> void:
	is_pressed = true
	change.emit()
