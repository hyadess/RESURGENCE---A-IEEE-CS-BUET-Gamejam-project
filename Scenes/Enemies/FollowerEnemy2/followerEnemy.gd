extends CharacterBody2D

var recorded_positions
var target_position
var do_follow = false;
var new_global_position;

func _ready():
	recorded_positions = get_parent().recorded_positions
	$AnimatedSprite2D.play("Run")

func _physics_process(delta):
	
	if position.y > 5000 : kill()
	
	#remove this later	
	if Input.is_action_just_pressed("force_quit"):
		get_tree().quit()

#func animation():
#
#	if facing == "left":
#		$AnimatedSprite2D.flip_h = true
#	else :
#		$AnimatedSprite2D.flip_h = false
#
#	if is_jumping: $AnimatedSprite2D.play("Jump")
#	elif is_running: $AnimatedSprite2D.play("Run")
#	elif is_idling: $AnimatedSprite2D.play("Idle")
#	pass

func kill():
	pass

#
#func _on_dash_timer_timeout():
#	can_dash=true

func _on_start_follow_timer_timeout():
	do_follow = true


func _on_follow_timer_timeout():
	print("here")
	print("size :", recorded_positions.size())
	if(do_follow and recorded_positions.size() > 0):
		print(recorded_positions[0])
		new_global_position = recorded_positions[0]
		if(new_global_position.x < global_position.x): 
			$AnimatedSprite2D.flip_h = true
			$Eyes.flip_h = true
		else :
			$AnimatedSprite2D.flip_h = false
			$Eyes.flip_h = false
		global_position = new_global_position
		#global_position = global_position.move_toward(recorded_positions[0], _delta * 4000)
		recorded_positions.remove_at(0)
