extends CanvasLayer

signal dialogue_start
signal dialogue_stop

var _dialogues = []
var _images = []
var _curr_no = 0

@onready var _dialogue_label = $ColorRect/Dialogue
@onready var _dialogue_back = $ColorRect
@onready var _speaker = $Sprite2D
@export var is_running:bool = false
@export var play_audio:bool = false


func _ready() -> void:
	_dialogue_label.visible = false
	_dialogue_back.visible = false
	_speaker.visible = false
	is_running = false


func set_dialogue(lines, images):
	_dialogues = lines
	_images = images
	_curr_no = 0
	
func start_dialogue():
	emit_signal("dialogue_start")
	_dialogue_back.visible = true
	is_running = true
	_dialogue_label.visible = true
	_speaker.visible = true
	_show_dialogue()
	Globals.showing_dialogue = true

func _show_dialogue():
	_dialogue_label.show_dialogue(_dialogues[_curr_no])
	$Sprite2D.texture = load("res://Assets/DialogueHeads/" + _images[_curr_no] + ".png")
	var speed = 0.9
#	if play_audio:
#		yield($TextToSpeech.say(_dialogues[_curr_no],  TextToSpeech.VOICE_SLT, speed), "completed")
	
func _stop_dialogue():
	_dialogue_back.visible = false
	_dialogue_label.visible = false
	_speaker.visible = false
	is_running = false
	emit_signal("dialogue_stop")
	Globals.showing_dialogue = false
	
func _next_dialogue():
	if _curr_no+1 < _dialogues.size():
		_curr_no+=1;
		_show_dialogue()
	else:
		_stop_dialogue()
