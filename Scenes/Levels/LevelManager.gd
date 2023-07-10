extends Node2D

var level : Node
var level_no : int

func _ready():
	load_level(Globals.level_to_load)

func _input(event):
	if Input.is_action_pressed("next_dialogue") and $DialogueManager.is_running:
		$DialogueManager._next_dialogue()
#	elif Input.is_action_pressed("skip_dialogue") and $DialogueManager.is_running:
#		$DialogueManager._stop_dialogue()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func load_level(level_no = 0):
	$InGameMenu/TimerIndicator.visible = false
	$InGameMenu/Pause.visible = false
	$DialogueManager._stop_dialogue()
	self.level_no = level_no
	if is_instance_valid(level) :
		level.queue_free()
		$Transition.fade_in()
		await get_tree().create_timer(0.6).timeout
		$Transition.fade_out()
	level = load("res://Scenes/Levels/Level" + str(level_no) + "/scene.tscn").instantiate()
	level.position = Vector2.ZERO
	$LevelContainer.add_child(level)
	
	# Connect signals
	level.level_clear.connect(on_level_clear)
	level.level_lost.connect(on_level_lost)
	
	Globals.level_lost = false

func restart_level():
	load_level(Globals.level_to_load)
	
func next_level():
	if Globals.has_next_level() : 
		Globals.set_next_level()
		load_level(Globals.level_to_load)
#	else: get_tree().change_scene("res://src/UI/Credit/Credit.tscn") # thank you scene

func on_level_clear():
	print("Got level clear")
	Globals.level_complete(level_no)
	next_level()

func on_level_lost():
	Globals.level_lost = true
	await get_tree().create_timer(1).timeout
	restart_level()
	

func _on_pause_menu_panel_exit_button():
	get_tree().paused = false
	$InGameMenu/Pause.visible = false
	Transition.change_scene("res://Scenes/UI/Main/main_menu.tscn")

func _on_pause_menu_panel_restart_button():
	$InGameMenu/Pause.visible = false
	get_tree().paused = false
	restart_level()


func _on_pause_menu_panel_resume_button():
	get_tree().paused = false
	$InGameMenu/Pause.visible = false


func play_dialogues(dialogues, images):
	$DialogueManager.set_dialogue(dialogues, images)
	$DialogueManager.start_dialogue()

func activate_level_timer():
	$InGameMenu/TimerIndicator.visible = true
	$InGameMenu/TimerIndicator/TextureProgressBar.value = 100
	
func update_level_timer(val):
	$InGameMenu/TimerIndicator/TextureProgressBar.value = val
