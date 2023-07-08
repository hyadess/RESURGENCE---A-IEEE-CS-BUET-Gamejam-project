extends CanvasLayer

signal scene_changed()

@onready var animation_player  = $AnimationPlayer
@onready var black = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play_backwards("fade_to_black")
	pass # Replace with function body.

func change_scene(path, delay = 0):
	await get_tree().create_timer(delay).timeout
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(path)
	animation_player.play_backwards("fade_to_black")
	await animation_player.animation_finished
	emit_signal("scene_changed")
	
