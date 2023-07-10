extends Node2D

var recorded_positions := []

#signals
signal level_clear
signal level_lost


var camera : Camera2D
var is_player_alive : bool
var call_again = true


var show_starter_dialogue = false

var dialogues = ["Hello young knight. Where are you going?", "To a foreign land, on the other side of the forest.", "You're a brave one, aren't you?", "People don't usually dare to go there.", "Why?", "No one ever comes back alive. People say they meet their inner demons there.", "That's just a myth, old man."]
var images = ["Bigguy", "player", "Bigguy","Bigguy","player", "Bigguy","player"]
var shown_dialogues = false
var show_mirror_dialogue = false
var met_ghost = false

# Called when the node enters the scene tree for the first time.
func _ready():
	is_player_alive = true
	camera = $Player/Camera2D
	camera.make_current()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if call_again: check_lose_condition()
	if call_again: check_win_condition()
	
	
	var big_guy_pos = $AnimatedSprite2D.global_position
	var player_pos = $Player.global_position
	
	if player_pos.x < big_guy_pos.x : $AnimatedSprite2D.flip_h = true
	else : $AnimatedSprite2D.flip_h = false
	
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
	#recorded_positions.append(pos)
	pass
	
	
func _on_record_pos_timer_timeout():
	if is_player_alive:
		add_position($Player.global_position)
		
# ================================== Record Position ================================	

func _on_start_follow_timer_timeout():
	#$Player2.do_follow = true
	pass


func _on_area_2d_area_entered(area):
	#need to show dialogues
	if not shown_dialogues:
		get_parent().get_parent().play_dialogues(dialogues, images)
		shown_dialogues = true



func _on_area_before_mirror_area_entered(area):
	#need to show dialogues
	if not show_mirror_dialogue:
		get_parent().get_parent().play_dialogues(["Strange! What is this mirror doing here?"], ["player"])
		show_mirror_dialogue = true


func _on_area_in_front_of_mirror_area_entered(area):
	if not met_ghost:
		met_ghost = true
		$Node2D.visible = true
		get_parent().get_parent().play_dialogues(["What is that???"], ["player"])
		$Player.restrict_movement = true
		await get_tree().create_timer(2).timeout
		$Transition.fade_in()
		await get_tree().create_timer(2).timeout
		$Transition.fade_out()
		$Node2D.visible = false
		$"Mirror-01".visible = false
		get_parent().get_parent().play_dialogues(["What was that light??? Where did the mirror go?"], ["player"])
		await get_tree().create_timer(3).timeout
		emit_signal("level_clear")
		
	pass # Replace with function body.
