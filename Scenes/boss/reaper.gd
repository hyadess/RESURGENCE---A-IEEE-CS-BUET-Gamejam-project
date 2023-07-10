extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


#states

var is_attacking=false
var is_bombing=false
var is_idle=false
var is_running=false

var can_attack=false
var can_bomb=false


func _ready():
	$attack_timer.start()
	$bomb_timer.start()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	
	
	#find the player's position, decisions will be made with it......
	var currentNode=self
	var sibling=currentNode.get_parent().get_node("Player")
	var siblingPositon=sibling.get_position()
	
	
	#update states...
	var direction
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
		
	
	#update x..............
	
	if abs(siblingPositon.x - position.x) <50:
		attack_decision()
	
	if is_attacking or is_bombing:
		is_running=false

	if is_running:
		velocity.x = direction * SPEED
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	update_animation(direction)

	move_and_slide()




func update_animation(direction):
	if direction==1:
		$AnimatedSprite2D.flip_h=false
	elif direction==-1:
		$AnimatedSprite2D.flip_h=true
		
	if is_idle:
		$AnimatedSprite2D.play("idle")
	if is_running:
		$AnimatedSprite2D.play("run")
	if is_attacking:
		$AnimatedSprite2D.play("attack")





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
		

func _on_attack_timer_timeout():
	can_attack=true


func _on_bomb_timer_timeout():
	can_bomb=true
	



func _on_animated_sprite_2d_animation_finished():
	if is_attacking:
		is_attacking=false
	if is_bombing:
		is_bombing=false
