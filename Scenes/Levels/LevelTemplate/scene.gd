extends Node2D

var recorded_positions := []

#signals
signal level_clear
signal level_lost


var camera : Camera2D
var is_player_alive : bool
var call_again = true


# Called when the node enters the scene tree for the first time.
func _ready():
	is_player_alive = true
	camera = $Player/Camera2D
	camera.make_current()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if call_again: check_lose_condition()
	if call_again: check_win_condition()	
	
	if Input.is_action_just_pressed("force_quit"):
		get_tree().quit()

# Caution : Check if player is alive before using $Player
func check_win_condition():
	pass


func check_lose_condition():
	if not is_player_alive:
		call_again = false
		emit_signal("level_lost")
		

func _on_player_player_died():
	is_player_alive = false
	if call_again:check_lose_condition()
	if call_again:check_win_condition()

# ================================== Record Position ================================		
func add_position(pos):
	#if(recorded_positions.size() == 0):
	recorded_positions.append(pos)
	
	
func _on_record_pos_timer_timeout():
	if is_player_alive:
		add_position($Player.global_position)
		
# ================================== Record Position ================================	

func _on_start_follow_timer_timeout():
	#$Player2.do_follow = true
	pass

