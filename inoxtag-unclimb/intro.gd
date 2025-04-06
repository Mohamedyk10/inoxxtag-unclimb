extends Node2D
signal intro_finish

var messages = [
	"Mount Everest, the tallest summit on Earth. Conquering it is no easy feat.\nReaching the summit remains a dream cherished by many.",
	"This individual achieved the remarkable milestone of reaching the summit after\nintense training and the unwavering support of his team. They turned the\ndream of standing at the highest point on Earth into reality.",
	"However, while descending the mountain, he encountered an unimaginable\nthreat—a Yeti. He ran for his life, faster than he ever thought possible. No\none had ever suspected the existence of such a creature.",
	"In his frantic escape, he stumbled upon a cave. Seeking refuge, he entered,\nhoping to find a hiding spot. The Yeti did not follow him inside, but now the\nhiker must navigate the cave's depths to find another way out."
];
var typing_speed = .05
var read_time = 3

var current_message = 0
var display = ""
var current_char = 0

func _ready():
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("JUMP"):
		stop_dialogue()
		emit_signal("intro_finish")

func start_dialogue():
	current_message = 0
	display = ""
	current_char = 0
	
	$next_char.set_wait_time(typing_speed)
	$next_char.start()

func stop_dialogue():
	#get_parent().remove_child(self)
	queue_free()

func _on_next_char_timeout():
	if (current_char < len(messages[current_message])):
		var next_char = messages[current_message][current_char]
		display += next_char
		
		$Label.text = display
		current_char += 1
	else:
		$next_char.stop()
		$next_message.one_shot = true
		$next_message.set_wait_time(read_time)
		$next_message.start()

func _on_next_message_timeout():
	if (current_message == len(messages) - 1):
		stop_dialogue()
		emit_signal("intro_finish")
	else: 
		current_message += 1
		display = ""
		current_char = 0
		if current_message==1:
			$Everest.hide()
		elif current_message==2:
			$SommetEverest.hide()
		elif current_message==3:
			$PoursuiviParYeti.hide()
		$next_char.start()


func _on_pre_intro_finish() -> void:
	start_dialogue()
	pass # Replace with function body.
