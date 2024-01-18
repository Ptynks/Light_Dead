extends RigidBody2D

@export var bullet_damage = 1 

@onready var parent = get_parent()

func _physics_process(delta):
	if parent.global_position.x > global_position.x:
		position.x += -500 * delta
	else:
		position.x += 500 * delta
		$AnimatedSprite2D.flip_h = true
	if position.x <= -5000 or position.x > 5000:
		queue_free()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		body.damage(bullet_damage, position.x)
	queue_free()
