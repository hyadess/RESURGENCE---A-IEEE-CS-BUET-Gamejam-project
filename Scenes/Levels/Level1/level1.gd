extends Node2D

var recorded_positions := []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_position(pos):
	#if(recorded_positions.size() == 0):
	recorded_positions.append(pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("force_quit"):
		get_tree().quit()


func _on_record_pos_timer_timeout():
	add_position($Player.global_position)


func _on_start_follow_timer_timeout():
	#$Player2.do_follow = true
	pass
