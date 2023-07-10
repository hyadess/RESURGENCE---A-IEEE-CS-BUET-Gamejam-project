extends CharacterBody2D


var speed = 300.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	if is_on_floor():
		var f=is_instance_valid(self)
		if f:
			queue_free()
	velocity.y += 200 * delta
	velocity.x =speed

	move_and_slide()

func set_x_position(p,q):
	position.x=p
	position.y=-300
	speed=q
	set_physics_process(true)
	$AnimatedSprite2D.play("active")
	
	

