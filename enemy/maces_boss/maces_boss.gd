extends RigidBody2D

@export var health = 50
@export var boss_damage = 1
@export var speed = 250
var target
var in_fight = false
var slow = 100
var in_range = false

@onready var cooldown = $Timer

func _physics_process(_delta):
	if in_fight:
		if $Wait.time_left == 0:
			position += (target.position - position) / slow
			if target.position > position:
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.offset.x = -3
				$HitBox/CollisionShape2D.position.x = $right.position.x
			else:
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.offset.x = 3
				$HitBox/CollisionShape2D.position.x = $left.position.x
	
	if cooldown.time_left <= 1:
		if in_range:
			if $AnimatedSprite2D.flip_h == true:
				$Flash_Danger.position = Vector2(-26, -22)
			else:
				$Flash_Danger.position = Vector2(26, -22)
			$Flash_Danger/AnimatedSprite2D.play("default")
			$Flash_Danger/AnimatedSprite2D.visible = true
	else:
		$Flash_Danger/AnimatedSprite2D.visible = false
	
	if cooldown.time_left <= 0.0:
		attack()
	else:
		$HitBox/CollisionShape2D.disabled = true

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		target = body
		in_fight = true

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		target = null
		in_fight = false

func _on_attack_range_body_entered(body):
	if body.name == "Player":
		in_range = true

func _on_attack_range_body_exited(body):
	if body.name == "Player":
		in_range = false

func attack():
	cooldown.start()
	$Wait.start()
	$HitBox/CollisionShape2D.disabled = false
	$AnimatedSprite2D.play("attack")
	$Flash_Danger/AnimatedSprite2D.visible = false

func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play("idle")

func _on_hit_box_body_entered(body):
	if body.name == "Player":
		body.damage(boss_damage)

func damage(player_damage):
	health -= player_damage
	$popup_location.popup(player_damage)
	$Canvas/TextureProgressBar.update(health)
	if health <= 0:
		queue_free()
