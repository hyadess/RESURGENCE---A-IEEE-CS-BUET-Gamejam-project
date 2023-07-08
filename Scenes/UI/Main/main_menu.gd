extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_exit_pressed():
	get_tree().quit()


func _on_play_pressed():
	Transition.change_scene("res://Scenes/UI/Main/main_menu2.tscn")
	pass # Replace with function body.
