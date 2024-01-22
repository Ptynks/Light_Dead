extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_left_direction = true
@export var speed = 100
@onready var movement_time = $MovementTime
@onready var animated = $AnimatedSprite2D

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if movement_time.time_left == 0:
		movement_time.start()
		is_left_direction = !is_left_direction
	
	if movement_time.time_left > 3:
		run(delta)
		animated.play("run")
	else:
		velocity.x = 0
		animated.play("idle")
	print(movement_time.time_left)
	
	move_and_slide()

func run(delta):
	if is_left_direction:
		velocity.x -= speed * delta
		animated.flip_h = true
		animated.position = Vector2(-47, 0)
	else:
		velocity.x += speed * delta
		animated.flip_h = false
		animated.position = Vector2(47, 0)
