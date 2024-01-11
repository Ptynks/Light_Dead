extends RigidBody2D

@export var slow = 50 # càng thấp quái đi càng nhanh
var player_chase = false
var player = null
var animatedSprite2D = null
@export var enemyHealth = 10.0
var move_left = true
var light
@export var enemy_damage = 1

func _ready():
	animatedSprite2D = $AnimatedSprite2D
	animatedSprite2D.play("default")
	light = $PointLight2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_chase:
		position += (player.position - position) / slow
		if player.position > position:
			animatedSprite2D.flip_h = true
		else:
			animatedSprite2D.flip_h = false
	else:
		if move_left:
			position += Vector2((randf() * 10) * -1, 0)
		else:
			position += Vector2((randf() * 10) * 1, 0)
	move_and_collide(Vector2(0,0))

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	light.color = Color(1, 0.145, 0.11)

func _on_detection_area_body_exited(_body):
	player = null
	player_chase = false
	light.color = Color(1, 1, 1)

func damage(damage):
	enemyHealth -= damage
	$popup_location.popup(damage)
	if enemyHealth <= 0:
		animatedSprite2D.play("dead")

func _on_animated_sprite_2d_animation_finished():
	queue_free()

func _on_timer_timeout():
	if randf() > 0.5:
		move_left = true
		animatedSprite2D.flip_h = false
	else:
		move_left = false
		animatedSprite2D.flip_h = true

func _on_hit_box_body_entered(body):
	if body.name == "Player":
		body.damage(enemy_damage)
		animatedSprite2D.play("dead")
