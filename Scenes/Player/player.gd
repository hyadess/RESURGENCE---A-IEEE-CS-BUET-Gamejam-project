extends CharacterBody2D


signal player_died

#for dash
@onready var dash=$Dash
@export var dash_speed=12000
@export var dash_jump_strength=1000
@export var dash_double_jump_strength=500
@export var dash_duration=0.06
@export var can_dash=true


@export var actual_speed = 300.0 #400 chiilo
@export var actual_jump_strength = 50000.0
@export var actual_double_jump_strength = 60000.0
@export var maximum_jumps = 2
@export var gravity = 4500
@export var max_fall_speed = 10000


var jumps_made = 0
var speed = 0
var jump_strength = 0
var double_jump_strength = 0
var prior_vertical_velocity = 0

#states
var is_falling = false
var is_jumping = false
var is_double_jumping = false
var is_jump_cancelled = false
var is_idling = false
var is_running = false
var is_grounded = false
var facing = "right"
var is_alive = false
var is_attacking=false

func _ready():
	is_alive = true

func _ready():
	is_alive = true

func _physics_process(delta):
	
	if Input.is_action_just_pressed("dash"):
		
		#kill()
		pass
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if velocity.y >= max_fall_speed :
		velocity.y = max_fall_speed
		
	
	if not Globals.showing_dialogue :
		
		#dash
		if Input.is_action_just_pressed("dash") and dash.is_dashing()==false and can_dash==true and not is_idling :
			dash.start_dash($AnimatedSprite2D,dash_duration)
			$dashSound.play()
			can_dash=false
			$DashTimer.start()
		if Input.is_action_just_pressed("jump"):
			$jumpSound.play()
			
		
		
		speed = dash_speed if dash.is_dashing() else actual_speed
		jump_strength = dash_jump_strength if dash.is_dashing() else actual_jump_strength
		double_jump_strength = dash_double_jump_strength if dash.is_dashing() else actual_double_jump_strength
		
		velocity.x = clamp(velocity.x, -speed, speed)
	
		if Input.is_action_pressed("right"):
			velocity.x += speed * delta
			facing = "right"
			
		elif Input.is_action_pressed("left"):
			velocity.x -= speed * delta
			facing = "left"

		else:
			velocity.x = lerpf(velocity.x, 0, 0.2)
			
	
	# States
	is_falling = velocity.y > 0.0 and not is_on_floor()
	is_jumping = Input.is_action_just_pressed("jump") and is_on_floor()
	is_double_jumping = Input.is_action_just_pressed("jump") and (is_falling or is_jumping or not is_on_floor())
	is_jump_cancelled = Input.is_action_just_released("jump") and velocity.y < 0.0
	is_idling = is_on_floor() and not (Input.is_action_pressed("left") or Input.is_action_pressed("right"))
	is_running = is_on_floor() and (Input.is_action_pressed("left") or Input.is_action_pressed("right"))
	is_grounded = is_on_floor()
	
	if Globals.showing_dialogue:
		is_jumping = false
		is_double_jumping = false
		is_jump_cancelled = false
		is_idling = true
		is_running = false
		is_grounded = true
		


	# handle jump
	if is_jumping:
		jumps_made += 1
		velocity.y = -jump_strength*delta
	
	
	elif is_double_jumping:
		jumps_made += 1
		dash.start_dash($AnimatedSprite2D,dash_duration)
		can_dash=false
		$DashTimer.start()
		if jumps_made <= maximum_jumps:
			velocity.y = -double_jump_strength*delta
				
	elif is_idling or is_running:
		jumps_made = 0
	
	
	prior_vertical_velocity=velocity.y
	
	#move
	if Globals.showing_dialogue :
		velocity.x = 0
	
	move_and_slide()
	animation()
	
	var was_grounded = is_grounded
	is_grounded = is_on_floor()
	
	if was_grounded == null || was_grounded != is_grounded:
		emit_signal("grounded_updated", is_grounded)
		pass
		
	
	if Input.is_action_just_pressed("attack") and is_attacking==false:
		$sword_slash.visible=true
		$slashSound.play()
		$sword_slash.play("slash")
		$sword_collision.visible=true
		$sword.visible=true
		$sword.play()
		is_attacking=true
		
		
	

	if position.y > 5000 : kill()
	
	#remove this later	
	if Input.is_action_just_pressed("force_quit"):
		get_tree().quit()

func animation():
	
	if facing == "left":
		$AnimatedSprite2D.flip_h = true
	else :
		$AnimatedSprite2D.flip_h = false
		
	if is_jumping: $AnimatedSprite2D.play("Jump")
	elif is_running: $AnimatedSprite2D.play("Run")
	elif is_idling: $AnimatedSprite2D.play("Idle")
	
	pass

func kill(wait_time = 0.5):
	if not is_alive : return
	
	is_alive = false
	$AnimatedSprite2D.visible = false
	$sword_slash.visible = false
	$Dash.visible = false
	$DashGhosts.visible = false
	$Explosion.visible = true
	$Explosion.play("default")
	$CollisionShape2D.disabled = true
	$sword_collision/CollisionShape2D.disabled = true
	emit_signal("player_died")
	set_physics_process(false)
	set_process(false)
	
#	await get_tree().create_timer(wait_time).timeout
	#queue_free()



func _on_dash_timer_timeout():
	can_dash=true
	
	

func _on_sword_slash_animation_finished():
	$sword_slash.visible=false
	$sword_collision.visible=false
	$sword.visible=false  
	is_attacking=false
	
