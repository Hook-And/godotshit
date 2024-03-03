extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var chase = false
var speed = 100

@onready var anim = $AnimatedSprite2D
var alive = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var player = $"../../Player/Player"
	var direction = (player.position - self.position).normalized()
	
	if alive == true:
		if chase == true:
			velocity.x = direction.x * speed
			anim.play("Run")
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			anim.play("Idle")
		
		if direction.x < 0:
			anim.flip_h = true
			anim.offset.x = -4.66
		elif direction.x > 0:
			anim.flip_h = false
			anim.offset.x = 0
	
	move_and_slide()


func _on_detector_body_entered(body):
	if body.name == "Player":
		chase = true
	

func _on_detector_body_exited(body):
	if body.name == "Player":
		chase = false

func _on_death_body_entered(body):
	if body.name == "Player":
		anim.play("Death")
		body.velocity.y -= 300
		death()
		
#func _on_death_2_body_entered(body):
#	if body.name == "Player":
#		

func death ():
	alive = false
	await anim.animation_finished
	queue_free()



