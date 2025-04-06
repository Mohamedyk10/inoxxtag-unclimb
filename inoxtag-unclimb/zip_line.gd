extends Area2D

# Coordinates: ((a, b), (c, d))
var coefs

func _ready() -> void:
	var RECT = $CollisionShape2D.shape.get_rect()
	coefs = Vector4(RECT.position[0] + position[0], RECT.position[1] + position[1], RECT.end[0] + position[0], RECT.end[1] + position[1])

func f(x: float, coefs: Vector4) -> float:
	var A = coefs[0]
	var B = coefs[1]
	var C = coefs[2]
	var D = coefs[3]
	return (D - B) / (C - A) * x + B - (D - B) / (C - A) * A

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var x = body.global_position[0]
		var y = f(x, coefs)
		print(x, y)
		body.global_position = Vector2(x, y)
		body.move_and_slide()
		body.zip_line_coefs = coefs

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		body.zip_line_coefs = null
