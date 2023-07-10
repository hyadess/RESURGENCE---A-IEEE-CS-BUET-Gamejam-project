extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_exit_pressed():
	get_tree().quit()


func _on_play_pressed():
	#if Globals.level_to_load == 0:
	Transition.change_scene("res://Scenes/Levels/LevelManager.tscn")	
	#else :
		#pass


func _on_instructiuons_pressed():
	Transition.change_scene("res://Scenes/UI/Control/control.tscn")
