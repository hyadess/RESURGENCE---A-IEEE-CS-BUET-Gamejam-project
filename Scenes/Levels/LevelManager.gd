extends Node2D

var level : Node
var level_no : int

func _ready():
	load_level(Globals.level_to_load)

func load_level(level_no, play_dialogues = true):
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_pause_menu_panel_exit_button():
	get_tree().paused = false
	$InGameMenu/Pause.visible = false
	#get_tree().change_scene("res://src/Main/Game.tscn")


func _on_pause_menu_panel_restart_button():
	$InGameMenu/Pause.visible = false
	get_tree().paused = false
	#restart_level()


func _on_pause_menu_panel_resume_button():
	get_tree().paused = false
	$InGameMenu/Pause.visible = false
