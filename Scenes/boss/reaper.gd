extends CharacterBody2D


@export var actual_speed = 400.0
@export var actual_jump_strength = 50000.0
@export var actual_double_jump_strength = 60000.0
@export var maximum_jumps = 2
@export var gravity = 4500
@export var max_fall_speed = 10000

# Get the gravity from the project settings to be synced with RigidBody nodes.

var fireballPath=preload("res://Scenes/boss/fireBall.tscn")

var mode=0 #1 for AI, 2 for player..................


#states

var is_attacking=false
var is_bombing=false
var is_idle=false
var is_running=false

var can_attack=false
var can_bomb=false

#for mode 2.....
var is_falling=false
var is_jumping=false
var is_double_jumping=false
var is_jump_cancelled=false
var is_grounded=false

var jumps_made=0

var siblingPositon


func _ready():
	$attack_timer.start()
	$bomb_timer.start()
	is_idle=true
	mode=1

func _physics_process(delta):
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if velocity.y >= max_fall_speed :
		velocity.y = max_fall_speed
		
	var direction
		
	if Input.is_action_just_pressed("switch_mode"):
		switch_mode(mode)
		
		
	#for mode 2*****************************
	if mode==2:
		direction=0
		if Input.is_action_pressed("right"):
			velocity.x += actual_speed * delta
			direction=1
		elif Input.is_action_pressed("left"):
			velocity.x -= actual_speed * delta
			direction=-1
		else:
			velocity.x = lerpf(velocity.x, 0, 0.2)

		if Input.is_action_just_pressed("attack") and is_attacking==false:
			is_attacking=true
			$slashSound.play()
			$AnimatedSprite2D.play("attack")

		# States
		is_falling = velocity.y > 0.0 and not is_on_floor()
		is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
		is_double_jumping = Input.is_action_just_pressed("jump") and (is_falling or is_jumping or not is_on_floor())
		is_jump_cancelled = Input.is_action_just_released("jump") and velocity.y < 0.0
		is_idle = is_on_floor() and not (Input.is_action_pressed("left") or Input.is_action_pressed("right"))
		is_running = is_on_floor() and (Input.is_action_pressed("left") or Input.is_action_pressed("right"))
		is_grounded = is_on_floor()



		# handle jump
		if is_jumping:
			jumps_made += 1
			velocity.y = -actual_jump_strength*delta
	
		elif is_double_jumping:
			jumps_made += 1
			if jumps_made <= maximum_jumps:
				velocity.y = -actual_double_jump_strength*delta
	
		elif is_idle or is_running:
			jumps_made = 0
	
	
	#for mode 1******************************************************

	if mode==1:
		#find the player's position, decisions will be made with it......
		var currentNode=self
		var sibling=currentNode.get_parent().get_node("Player")
		siblingPositon=sibling.get_position()


		#update states...

		if abs(siblingPositon.x - position.x) > 200:
			direction=0
			is_idle=true
			is_running=false
		elif siblingPositon.x< position.x:
			direction=-1
			is_idle=false
			is_running=true
		else:
			direction=1
			is_idle=false
			is_running=true
		
		bomb_decision()
		#update x..............
		if abs(siblingPositon.x - position.x) <50:
			#create_fireball(siblingPositon.x, position.x)
			attack_decision()

	
		if is_attacking or is_bombing:
			is_running=false
		

		if is_running:
			velocity.x += direction * actual_speed
		else:
			velocity.x = move_toward(velocity.x, 0, actual_speed)
		
	update_animation(direction)

	move_and_slide()


func switch_mode(m):
	if m==1:
		mode=2
	else:
		mode=1
	var is_attacking=false
	var is_bombing=false
	var is_idle=true
	var is_running=false

	var can_attack=false
	var can_bomb=false
	var is_falling=false
	var is_jumping=false
	var is_double_jumping=false
	var is_jump_cancelled=false
	var is_grounded=false

	var jumps_made=0

func update_animation(direction):
	if direction==1:
		$AnimatedSprite2D.flip_h=false
	elif direction==-1:
		$AnimatedSprite2D.flip_h=true
	if mode==1:
		if is_idle and $AnimatedSprite2D.animation!="idle":
			$AnimatedSprite2D.play("idle")
		if is_attacking and $AnimatedSprite2D.animation!="attack":
			$AnimatedSprite2D.play("attack")
		if is_running and $AnimatedSprite2D.animation!="run":
			$AnimatedSprite2D.play("run")
		if is_bombing and $AnimatedSprite2D.animation!="bombing":
			$AnimatedSprite2D.play("bombing")
	else:
		if is_attacking==false:
			if is_jumping or is_double_jumping: 
				$AnimatedSprite2D.play("run")
			elif is_running: 
				$AnimatedSprite2D.play("run")
			elif is_idle: 
				$AnimatedSprite2D.play("idle")


func create_fireball(a,b):
	if a>b:
		var temp=a
		a=b
		b=temp
	var fireball=fireballPath.instantiate()
	get_parent().add_child(fireball)
	fireball.set_x_position(randf_range(a,b),randf_range(-200,200))


func attack_decision():
	
	if can_attack==true and is_attacking==false and is_bombing==false:
		can_attack=false
		is_attacking=true
		$slashSound.play()
		is_idle=false
		is_running=false
		$attack_timer.start()
				
func bomb_decision():
	if can_bomb==true and is_attacking==false and is_bombing==false:
		can_bomb=false
		is_bombing=true
		is_idle=false
		is_running=false
		$bomb_timer.start()
		$bombing_time.start()
		$soul_timer.start()
		

func _on_attack_timer_timeout():
	if is_attacking==false:
		can_attack=true


func _on_bomb_timer_timeout():
	if is_bombing==false:
		can_bomb=true
	
	
func _on_animated_sprite_2d_animation_finished():
	#print("done")
	if is_attacking:
		is_attacking=false


func _on_soul_timer_timeout():
	if is_bombing:
		create_fireball(siblingPositon.x,position.x)


func _on_bombing_time_timeout():
	is_bombing=false
	$soul_timer.stop()
