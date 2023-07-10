extends Node2D

signal scene_changed()

@onready var animation_player  = $CanvasLayer/AnimationPlayer

func fade_in():
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	
func fade_out():
	animation_player.play_backwards("fade_to_black")
	await animation_player.animation_finished
