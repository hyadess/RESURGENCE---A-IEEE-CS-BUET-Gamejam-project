extends Node2D

var level : Node
var level_no : int

func _ready():
	load_level(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func load_level(level_no = 1, play_dialogues = false):
	$InGameMenu/Pause.visible = false
	
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

func restart_level():
	load_level(1)

func on_level_clear():
	print("Got level clear")
#	GameData.level_complete(level_no)
#	next_level()

func on_level_lost():
	Globals.level_lost = true
	await get_tree().create_timer(1).timeout
	restart_level()
	#$InGameMenu/LevelLost.visible = true

func _on_pause_menu_panel_exit_button():
	get_tree().paused = false
	$InGameMenu/Pause.visible = false
	#get_tree().change_scene("res://src/Main/Game.tscn")

func _on_pause_menu_panel_restart_button():
	$InGameMenu/Pause.visible = false
	get_tree().paused = false
	restart_level()


func _on_pause_menu_panel_resume_button():
	get_tree().paused = false
	$InGameMenu/Pause.visible = false
