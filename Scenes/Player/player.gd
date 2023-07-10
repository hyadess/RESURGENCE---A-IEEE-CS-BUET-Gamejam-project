extends CharacterBody2D


signal player_died
signal got_key

#for dash
@onready var dash=$Dash
@export var dash_speed=12000
@export var dash_jump_strength=1000
@export var dash_double_jump_strength=500
@export var dash_duration=0.06
@export var can_dash=true


@export var actual_speed = 400.0
@export var actual_jump_strength = 50000.0
@export var actual_double_jump_strength = 60000.0
@export var maximum_jumps = 2
@export var gravity = 4500
@export var max_fall_speed = 10000

@export var attack_enabled = true
@export var health = 100
@export var attack_damage = 100

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
var playing_attack_animiation = false
var rng = RandomNumberGenerator.new()
var is_attacking=false
var restrict_movement = false
@onready var sword_collision_x = $sword_collision/CollisionShape2D.position.x
@onready var sword_collision_x2 = $sword_collision2/CollisionShape2D.position.x
func _ready():
	is_alive = true

func _physics_process(delta):
	
#	if Input.is_action_just_pressed("dash"):
#		kill()
#		pass
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if velocity.y >= max_fall_speed :
		velocity.y = max_fall_speed
		
	
	if not Globals.showing_dialogue and not restrict_movement :
		
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
			
			
			
		if Input.is_action_just_pressed("attack") and attack_enabled and is_attacking==false:
			$sword_slash.visible=true
			$sword_slash.play("slash")
			$sword_collision.visible=true
			$sword_collision/CollisionShape2D.disabled = false
			$sword_collision2.visible=true
			$sword_collision2/CollisionShape2D.disabled = false
			is_attacking=true
			$slashSound.play()
			if(playing_attack_animiation == false):
				playing_attack_animiation = true
				var attack_idx = randi_range(2 ,3)
				$AnimatedSprite2D.play("Attack" + str(attack_idx))
			
	
	# States
	is_falling = velocity.y > 0.0 and not is_on_floor()
	is_jumping = Input.is_action_just_pressed("jump") and is_on_floor() and not restrict_movement
	is_double_jumping = Input.is_action_just_pressed("jump") and (is_falling or is_jumping or not is_on_floor()) and not restrict_movement
	is_jump_cancelled = Input.is_action_just_released("jump") and velocity.y < 0.0 
	is_idling = is_on_floor() and not (Input.is_action_pressed("left") or Input.is_action_pressed("right"))
	is_running = is_on_floor() and (Input.is_action_pressed("left") or Input.is_action_pressed("right")) and not restrict_movement
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
		#emit_signal("grounded_updated", is_grounded)
		pass
		
	if position.y > 5000 : kill()
	
	
	#remove this later	
	if Input.is_action_just_pressed("force_quit"):
		get_tree().quit()

func animation():
	
	if facing == "left":
		$AnimatedSprite2D.flip_h = true
		$sword_collision/CollisionShape2D.position.x = -sword_collision_x
		$sword_collision2/CollisionShape2D.position.x = -sword_collision_x2
		
	else :
		$AnimatedSprite2D.flip_h = false
		$sword_collision/CollisionShape2D.position.x = sword_collision_x
		$sword_collision2/CollisionShape2D.position.x = sword_collision_x2
	
	if not playing_attack_animiation:	
		if is_jumping or is_double_jumping: $AnimatedSprite2D.play("Jump")
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
	$sword_collision2/CollisionShape2D.disabled = true
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
	$sword_collision2.visible=false
	# $sword.visible=false
	is_attacking=false
	playing_attack_animiation = false
	$sword_collision/CollisionShape2D.disabled = true
	$sword_collision2/CollisionShape2D.disabled = true
	$AnimatedSprite2D.play("Idle")
	

func _on_area_2d_area_entered(area):
	if area.is_in_group("FollowerEnemy") and not area.get_parent().dying:
		kill()
	
	elif area.is_in_group("Key"):
		emit_signal("got_key")
		

func take_damage(val):
	health = min(0, health - val)
	if health <= 0:
		kill()


func _on_sword_collision_body_entered(body):
	if body.is_in_group("FollowerEnemy"):
		body.take_damage(attack_damage)


func _on_sword_collision_2_body_entered(body):
	if body.is_in_group("FollowerEnemy"):
		body.take_damage(attack_damage)
