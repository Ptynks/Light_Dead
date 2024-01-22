extends CharacterBody2D

@export var health = 50
@export var boss_damage = 1
@export var speed = 250
var target
var in_fight = false
var slow = 100
var in_range = false
var count_hit = 0
var on_skill = false
var round = 1
var bullet = preload("res://enemy/maces_boss/double_bullet.tscn")
var max_bullet = 1
var count_bullet = 0

@onready var cooldown = $Timer
@onready var damaged_sound = $DamagedSound
@onready var wait_time = $Wait
@onready var animated_sprite = $AnimatedSprite2D
@onready var hit_box = $HitBox/CollisionShape2D
@onready var flash_danger = $Flash_Danger
@onready var attack_sound = $AttackSound
@onready var skill_time = $Skill_Time

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if in_fight:
		if wait_time.time_left == 0 and !on_skill:
			position += (target.position - position) / slow
			if target.position > position:
				animated_sprite.flip_h = false
				animated_sprite.offset.x = -3
				hit_box.position.x = $right.position.x
			else:
				animated_sprite.flip_h = true
				animated_sprite.offset.x = 3
				hit_box.position.x = $left.position.x
	
	if skill_time.time_left == 0:
		on_skill = false
	
	if on_skill:
		if randi() % 2 >= 1:
			if animated_sprite.flip_h:
				velocity.x += -30000 * delta
			else:
				velocity.x += 30000 * delta
		else:
			if count_bullet < max_bullet:
				var bullet_ins = bullet.instantiate()
				add_child(bullet_ins)
				count_bullet += 1
				if animated_sprite.flip_h:
					bullet_ins.position = $left.position
				else:
					bullet_ins.position = $right.position
	
	if cooldown.time_left <= 1:
		if in_range:
			if animated_sprite.flip_h:
				flash_danger.position = Vector2(-26, -22)
			else:
				flash_danger.position = Vector2(26, -22)
			$Flash_Danger/AnimatedSprite2D.play("default")
			$Flash_Danger/AnimatedSprite2D.visible = true
	else:
		$Flash_Danger/AnimatedSprite2D.visible = false
	
	if cooldown.time_left <= 0.0:
		attack(delta)
	else:
		hit_box.disabled = true
	
	move_and_slide()

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

func attack(delta):
	if count_hit < 1:
		attack_sound.play()
		cooldown.start()
		wait_time.start()
		hit_box.disabled = false
		$AnimatedSprite2D.play("attack")
		$Flash_Danger/AnimatedSprite2D.visible = false
		count_hit += 1
		count_bullet = 0
	else:
		on_skill = true
		cooldown.start()
		wait_time.start()
		skill_time.start()
		count_hit = 0

func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play("idle")

func _on_hit_box_body_entered(body):
	if body.name == "Player":
		body.damage(boss_damage, position.x)

func damage(player_damage):
	damaged_sound.play()
	health -= player_damage
	$popup_location.popup(player_damage)
	$Canvas/TextureProgressBar.update(health)
	
	if round == 2:
		scale = Vector2(1.5, 1.5)
	
	if health <= 25:
		round = 2
		if health <= 0:
			queue_free()
