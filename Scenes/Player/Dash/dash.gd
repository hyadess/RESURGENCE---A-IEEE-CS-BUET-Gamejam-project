extends Node2D

@onready var dur_timer=$DurationTimer
var dash_ghost=preload("res://Scenes/Player/Dash/dash_ghost.tscn")
var sprite : AnimatedSprite2D


func _process(_delta):
	if !dur_timer.is_stopped():
		instance_ghost()


func start_dash(sprite, duration):
	self.sprite=sprite
	dur_timer.wait_time=duration
	dur_timer.start()
	$GhostTimer.start()
	#instance_ghost()
	
	
func is_dashing():
	return !dur_timer.is_stopped()
	
	
func instance_ghost():
	var node=dash_ghost.instantiate()
	var ghost = node.get_node("AnimatedSprite2D")
	ghost.global_position=global_position
#	ghost.texture=sprite.texture
#	ghost.vframes=sprite.vframes
#	ghost.hframes=sprite.hframes
	ghost.frame=sprite.frame
	ghost.flip_h=sprite.flip_h
	ghost.scale=sprite.scale
	ghost.global_scale=sprite.global_scale
	ghost.offset=sprite.offset
	get_parent().get_parent().add_child(node)
	

func _on_duration_timer_timeout():
	$GhostTimer.stop()
	


func _on_ghost_timer_timeout():
	instance_ghost()
	pass # Replace with function body.
