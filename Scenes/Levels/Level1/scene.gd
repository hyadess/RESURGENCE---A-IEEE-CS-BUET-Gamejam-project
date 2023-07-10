extends Node2D

var recorded_positions := []

#signals
signal level_clear
signal level_lost

@export var record_positions_enable = false

var camera : Camera2D
var is_player_alive : bool
var call_again = true
var met_enemy = false
var ghost_removed = false

var dialogues = ["You again! Who are you? ... What are you?", "I am you", "What?", "I am a part of you. A part that you want to lose. I am you trauma", "...", "There is no escape from me. I will chase you to the end", "See you soon"]
var images = ["player", "blue", "player","blue", "player", "blue", "blue"  ]
# Called when the node enters the scene tree for the first time.
func _ready():
	is_player_alive = true
	camera = $Player/Camera2D
	camera.make_current()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if call_again: check_lose_condition()
	if call_again: check_win_condition()
	
	if not Globals.showing_dialogue and met_enemy and not ghost_removed:
		remove_ghost()
	
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
	if is_player_alive and record_positions_enable:
		add_position($Player.global_position)
		
# ================================== Record Position ================================	

func _on_start_follow_timer_timeout():
	#$Player2.do_follow = true
	pass


func _on_area_2d_area_entered(area):
	if not met_enemy:
		met_enemy = true
		$FollowerEnemy.set_animation("Idle")
		$FollowerEnemy.flip_h()
		$FollowerEnemy.visible = true
		$FollowerEnemy.explosion()
		get_parent().get_parent().play_dialogues(dialogues,images)

func remove_ghost():
	ghost_removed = true
	$FollowerEnemy.set_animation("Idle")
	$FollowerEnemy.flip_h()
	$FollowerEnemy.explosion()
	$FollowerEnemy/AnimatedSprite2D.visible = false
	$FollowerEnemy/Eyes.visible = false
	get_parent().get_parent().play_dialogues(["Wait"], ["player"])
	await $FollowerEnemy/Explosion.animation_finished
	$FollowerEnemy.visible = false
	
	await get_tree().create_timer(1).timeout
	emit_signal("level_clear")
