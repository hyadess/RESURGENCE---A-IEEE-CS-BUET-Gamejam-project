extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	Globals.level_to_load = 5
	Transition.change_scene("res://Scenes/Levels/LevelManager.tscn")


func _on_button_2_pressed():
	Globals.level_to_load = 10
	Transition.change_scene("res://Scenes/Levels/LevelManager.tscn")


func _on_button_3_pressed():
	Globals.level_to_load = 11
	Transition.change_scene("res://Scenes/Levels/LevelManager.tscn")


func _on_button_4_pressed():
	Globals.level_to_load = 12
	Transition.change_scene("res://Scenes/Levels/LevelManager.tscn")

func _on_button_5_pressed():
	Globals.level_to_load = 0
	Transition.change_scene("res://Scenes/Levels/LevelManager.tscn")


func _on_button_6_pressed():
	Globals.level_to_load = 0
	Transition.change_scene("res://Scenes/Levels/LevelManager.tscn")


func _on_button_7_pressed():
	Globals.level_to_load = 0
	Transition.change_scene("res://Scenes/Levels/LevelManager.tscn")
