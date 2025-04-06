extends Node2D

var messages = [
	"JAMais 203"
];
var typing_speed = .05
var read_time = 3
signal finish
var current_message = 0
var display = ""
var current_char = 0

func _ready():
	start_dialogue()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("JUMP"):
		stop_dialogue()
		emit_signal("finish")
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
		emit_signal("finish")
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
