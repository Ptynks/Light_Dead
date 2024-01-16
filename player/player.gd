extends CharacterBody2D

var save_path = "player://data.save"
var direction
@export var SPEED = 300.0 
@export var JUMP_VELOCITY = -700.0 
@export var power_attack = 30 
var count_combo = false 
var current_direction = 0 
@export var HEALTH = 3
@export var DASH_POWER = 6500
@export var player_damage = 5
@export var MAX_STAMINA = 100
var current_stamina = 100
var stamina_need_to_dash = 30
var can_dash = true
@export var stamina_restore = 10

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") #lấy lwujc hấp dẫn được cài sẵn trong setting của game

@onready var animation = $AnimationPlayer # lấy thư viện animation
@onready var coyote_jump_time = $CoyoteJumpTimer # lấy thư viện đếm thời gian dùng cho coyote jump
@onready var animation_tree = $AnimationTree["parameters/playback"]
@onready var dash_timer = $DashTimer
@onready var attack_cooldown = $AttackCooldown
@onready var stamina_progess_bar = $CanvasPlayer/StaminaBarTexture

func _ready():
	$pos/SwordHit/CollisionShape2D.disabled = true
	health_change()
	load_data()

func _physics_process(delta):
	# code trong này chạy lặp lại
	direction = 0 # hướng mặt nhân vật
	
	if not is_on_floor():
		velocity.y += gravity * delta 
	
	get_input()

func _process(_delta):
	
	if current_stamina >= stamina_need_to_dash:
		can_dash = true
	
	if current_stamina < MAX_STAMINA:
		if dash_timer.time_left == 0:
			dash_timer.start()
			current_stamina += stamina_restore
			stamina_progess_bar.update(current_stamina * 100 / MAX_STAMINA)

func health_change():
	for child in $HealthBar.get_children():
		child.queue_free()
	
	for i in range(HEALTH):
		var heart = Sprite2D.new()
		heart.texture = load("res://UI/icons/heart.png")
		heart.position = Vector2(30 * i, 0)
		heart.scale = Vector2(2, 2)
		heart.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		$HealthBar.add_child(heart)

func get_input():
	if Input.is_anything_pressed():
		if not Input.is_action_pressed("attack"):
			direction = Input.get_axis("ui_left", "ui_right")
		
		if direction != 0:
			velocity.x = direction * SPEED
			if direction == 1:
				$Sprite2D.flip_h = true
			else:
				$Sprite2D.flip_h = false
			animation_tree.travel("run")

		if Input.is_action_pressed("attack") and attack_cooldown.time_left == 0:
			animation_tree.travel("attack")
			attack_cooldown.start()
			velocity.x = 0
			if $Sprite2D.flip_h:
				$pos.rotation_degrees = 180
			else:
				$pos.rotation_degrees = 360
			return
		
		if Input.is_action_just_released("attack"):
			$pos/SwordHit/CollisionShape2D.disabled = true
		
		if Input.is_action_pressed("jump") and is_on_floor() or Input.is_action_pressed("jump") and coyote_jump_time.time_left > 0.0:
			velocity.y = JUMP_VELOCITY
			animation_tree.travel("begin_jump")
		
		if Input.is_action_just_pressed("dash") and can_dash == true:
			velocity.x = direction * DASH_POWER
			can_dash = false
			current_stamina -= stamina_need_to_dash
			stamina_progess_bar.update(current_stamina * 100 / MAX_STAMINA)
	else:
		velocity.x = 0
		$pos/SwordHit/CollisionShape2D.disabled = true
		animation_tree.travel("idle")
	
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_legde = was_on_floor and not is_on_floor() and velocity.y >=  0
	if just_left_legde:
		coyote_jump_time.start()

func damage(damage):
	HEALTH -= damage
	if HEALTH <= 0:
		player_dead()
	else:
		health_change()

func player_dead():
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")

func _on_sword_hit_body_entered(body):
	body.damage(player_damage)

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(SPEED)
	file.store_var(HEALTH)
	file.store_var(JUMP_VELOCITY)
	file.store_var(power_attack)
	file.store_var(DASH_POWER)
	file.store_var(player_damage)
	file.store_var(MAX_STAMINA)
	file.store_var(stamina_restore)

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		SPEED = file.get_var(SPEED)
		HEALTH = file.get_var(HEALTH)
		JUMP_VELOCITY = file.get_var(JUMP_VELOCITY)
		power_attack = file.get_var(power_attack)
		DASH_POWER = file.get_var(DASH_POWER)
		player_damage = file.get_var(player_damage)
		MAX_STAMINA = file.get_var(MAX_STAMINA)
		stamina_restore = file.get_var(stamina_restore)
	else:
		SPEED = 300.0 
		JUMP_VELOCITY = -700.0 
		power_attack = 30
		HEALTH = 3
		DASH_POWER = 6500
		player_damage = 5
		MAX_STAMINA = 100
		stamina_restore = 10

func is_player_in_floor():
	return is_on_floor()
