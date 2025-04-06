extends Area2D

# Coordinates: ((a, b), (c, d))
var coefs
var zip_code

func _ready() -> void:
	print("--------")
	var RECT = $CollisionShape2D.shape.get_rect()
	var A = Vector2(RECT.position[0], RECT.position[1])
	var r = sqrt(A[0] ** 2 + A[1] ** 2)
	var phi = atan2(A[1], A[0])
	phi += rotation
	print(r)
	print(phi)
	if A[0] < 0:
		phi += PI
	A = Vector2(r * cos(phi), r * sin(phi))
	var B = Vector2(RECT.end[0], RECT.end[1])
	r = sqrt(B[0] ** 2 + B[1] ** 2)
	phi = atan2(B[1], B[0])
	phi += rotation
	print(r)
	print(phi)
	if B[0] < 0:
		phi += PI
	B = Vector2(r * cos(phi), r * sin(phi))
	
	coefs = Vector4(A[0], A[1], B[0], B[1])
	print(coefs)
	
	coefs[0] += position[0]
	coefs[1] += position[1]
	coefs[2] += position[0]
	coefs[3] += position[1]
	
	if coefs[1] < coefs[3]:
		coefs = Vector4(coefs[2], coefs[3], coefs[0], coefs[1])

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.zip_line_coefs = coefs

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		body.zip_line_coefs = null

func _on_child_entered_tree(node: Node) -> void:
	var childrenName = node.name
	if len(childrenName) == 1:
		zip_code = int(childrenName)
