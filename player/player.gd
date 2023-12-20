extends CharacterBody2D

enum {
	IDLE,
	RUN,
	ATTACK
}

const SPEED = 300.0
const JUMP_VELOCITY = -700.0
var state = IDLE
var power_attack = 30
var count_combo = false
var current_direction = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation = $AnimationPlayer

func _ready():
	$pos/SwordHit/CollisionShape2D.disabled = true

func _physics_process(delta):
	var direction = 0
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.get_axis("ui_left", "ui_right"):
		direction = Input.get_axis("ui_left", "ui_right")
		state = RUN
		current_direction = direction
	elif Input.is_action_just_pressed("attack") and is_on_floor():
		state = ATTACK
		count_combo = !count_combo
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_anything_pressed() == false and state != ATTACK:
		state = IDLE
	
	match state:
		RUN:
			animation.play("run")
			run_state(direction)
		IDLE:
			velocity.x = 0
			animation.play("idle")
			idle_state()
		ATTACK:
			in_combo()
			attack_state(current_direction)
	
	move_and_slide()

func run_state(direction):
	# var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
func idle_state():
	pass
	
func attack_state(current_direction):
	velocity.x = current_direction * power_attack
	
func finished_attack():
	state = IDLE

func in_combo():
	if $Sprite2D.flip_h:
		$pos.rotation_degrees = 180
	else:
		$pos.rotation_degrees = 360
	
	if count_combo:
		animation.play("attack")
	elif !count_combo:
		animation.play("double_attack")

func _on_sword_hit_area_entered(area):
	print("hello")
