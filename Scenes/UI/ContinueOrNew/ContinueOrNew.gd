extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("secret_key"):
		Transition.change_scene("res://Scenes/UI/LevelSelector/level_selector.tscn")

func _on_button_pressed(): #continue
	Transition.change_scene("res://Scenes/Levels/LevelManager.tscn")
	
func _on_button_2_pressed():
	Globals.level_to_load = 0
	Transition.change_scene("res://Scenes/Levels/LevelManager.tscn")
