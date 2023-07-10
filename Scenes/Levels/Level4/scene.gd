extends Node2D

var recorded_positions := []

#signals
signal level_clear
signal level_lost

var camera : Camera2D
var is_player_alive : bool
var call_again = true

@export var timelimit = 20
@export var is_timelimit = true
@export var record_positions_enable = true
@export var infinite_enemy = false
@export var enemies_to_spawn = 1
var enemies_spawned = 0
@onready var player_initial_position = $Player.global_position
@export var start_distance = 200
var player_started_moving = false
var started_spawning = false
var time_elapsed = 0
var got_key = false

# Called when the node enters the scene tree for the first time.
func _ready():
	is_player_alive = true
	camera = $Player/Camera2D
	camera.make_current()
	if is_timelimit:
		get_parent().get_parent().activate_level_timer()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if call_again: check_lose_condition()
	if call_again: check_win_condition()
	
	if is_player_alive and not started_spawning and absf($Player.global_position.x - player_initial_position.x) > start_distance:
		started_spawning = true
		player_started_moving = true
		record_positions_enable = true
		$StartFollowTimer.start()
		spawn_enemy(player_initial_position)
		$LevelTimer.start()
	
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
func _on_record_pos_timer_timeout():
	if is_player_alive and record_positions_enable:
		recorded_positions.append($Player.global_position)
		
# ================================== Record Position ================================	

func _on_start_follow_timer_timeout():
	if infinite_enemy or enemies_spawned < enemies_to_spawn:
		spawn_enemy(player_initial_position)

func spawn_enemy(pos):
	var enemy =  load("res://Scenes/Enemies/FollowerEnemy/followerEnemy.tscn").instantiate()
	enemy.global_position = pos
	enemy.do_follow = true
	enemies_spawned += 1
	$Enemies.add_child(enemy)

func _on_level_timer_timeout():
	time_elapsed += $LevelTimer.wait_time
	if(time_elapsed >= timelimit) : 
		$Player.kill()
	else:
		get_parent().get_parent().update_level_timer(100 - time_elapsed/timelimit*100)


func _on_player_got_key():
	got_key = true
	$Key.visible = false
	$Key/Area2D/CollisionShape2D.disabled = true


func _on_exit_body_entered(body):
	if got_key and body.is_in_group("Player"):
		emit_signal("level_clear")
