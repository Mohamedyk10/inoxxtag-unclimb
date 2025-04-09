extends Node2D
var time = 0
@export var checkpoint1 = false
@export var checkpoint2 = false
@export var checkpoint3 = false
@export var checkpoint4 = false
@export var ended = false
var checkpoint1_time = false
var checkpoint2_time = false
var checkpoint3_time = false
var checkpoint4_time = false

func _ready() -> void:
	$Checkpoint1.hide()
	$Checkpoint2.hide()
	$Checkpoint3.hide()
	$Checkpoint4.hide()
	
func _process(delta: float) -> void:
	if not ended:
		time += delta
	var ms = fmod(time, 1)*100
	var seconds = fmod(time, 60)
	var minutes = fmod(time, 3600)/60
	$Timer/MilliSeconds.text = "%02d" % ms
	$Timer/Seconds.text = "%02d." % seconds
	$Timer/Minutes.text = "%02d:" % minutes
	
	if checkpoint1 and not checkpoint1_time:
		$Checkpoint1/MilliSeconds.text = "%02d" % ms
		$Checkpoint1/Seconds.text = "%02d." % seconds
		$Checkpoint1/Minutes.text = "%02d:" % minutes
		checkpoint1_time = true
		$Checkpoint1.show()
	if checkpoint2 and not checkpoint2_time:
		$Checkpoint2/MilliSeconds.text = "%02d" % ms
		$Checkpoint2/Seconds.text = "%02d." % seconds
		$Checkpoint2/Minutes.text = "%02d:" % minutes
		checkpoint2_time = true
		$Checkpoint2.show()
	if checkpoint3 and not checkpoint3_time:
		$Checkpoint3/MilliSeconds.text = "%02d" % ms
		$Checkpoint3/Seconds.text = "%02d." % seconds
		$Checkpoint3/Minutes.text = "%02d:" % minutes
		checkpoint3_time = true
		$Checkpoint3.show()
	if checkpoint4 and not checkpoint4_time:
		$Checkpoint4/MilliSeconds.text = "%02d" % ms
		$Checkpoint4/Seconds.text = "%02d." % seconds
		$Checkpoint4/Minutes.text = "%02d:" % minutes
		checkpoint4_time = true
		$Checkpoint4.show()
	
	if not checkpoint1:
		$Checkpoint1.hide()
	if not checkpoint1:
		$Checkpoint2.hide()
	if not checkpoint1:
		$Checkpoint3.hide()
	if not checkpoint1:
		$Checkpoint4.hide()
	pass
