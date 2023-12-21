extends CharacterBody2D

#liệt kê các trạng thái người chơi có thể có
enum {
	IDLE,
	RUN,
	ATTACK
}

const SPEED = 300.0 #tốc độ di chuyển
const JUMP_VELOCITY = -700.0 #lực nhảy
var state = IDLE #trạng thái mặt định
var power_attack = 30 #đoạn cách nhân vật lướt nhẹ tới trước khi tấn công
var count_combo = false #đếm số đòn đánh người chơi thực hiện (để xen kẽ giữa 2 animation tấn công khác nhau)
var current_direction = 0 #hướng đi hiện tại của nhân vật tương ứng -1 0 1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") #lấy lwujc hấp dẫn được cài sẵn trong setting của game

@onready var animation = $AnimationPlayer # lấy thư viện animation
@onready var coyote_jump_time = $CoyoteJumpTimer # lấy thư viện đếm thời gian dùng cho coyote jump

func _ready():
	# code trong này dc chạy 1 lần khi game bắt đầu chạy
	$pos/SwordHit/CollisionShape2D.disabled = true #tắt hitbox đòn tấn công của nhân vật

func _physics_process(delta):
	# code trong này chạy lặp lại
	var direction = 0 # hướng mặt nhân vật
	
	if not is_on_floor():
		#nếu không đứng trên nền
		velocity.y += gravity * delta #rơi xuống theo trọng lực
	
	if Input.get_axis("ui_left", "ui_right"):
		#sự kiện khi nhấn nút di chuyển (a, d)
		direction = Input.get_axis("ui_left", "ui_right") #hướng của nhân vật được tính bằng cách nhận input của 2 nút a, d -1 = trái, 1 = phải 
		state = RUN #đặt trạng thái là run
		current_direction = direction
	elif Input.is_action_just_pressed("attack") and is_on_floor():
		# khi nhấn nút attack (j) và nhân vật đứng trên nền
		state = ATTACK #đặt trạng thái là tấn công
		count_combo = !count_combo # count combo được đặt ngược lại (nếu đang là true => false)
		
	if is_on_floor() or coyote_jump_time.time_left > 0.0:
		# sự kiến nếu nhân vật đứng trên nền và thời gian của coyote lớn hơn 0
		if Input.is_action_just_pressed("ui_accept"):
			# nếu người chơi nhấn nút accept (space)
			velocity.y = JUMP_VELOCITY #tạo một lực theo trục y bằng lực nhảy (nhảy lên)
		if not is_on_floor():
			# nêu không đứng trên nền
			if Input.is_action_just_released("ui_accept") and velocity.y < JUMP_VELOCITY / 2:
				#sự kiện người dùng thả nút accept (space) và trục y < lực nhảy / 2
				velocity.y = JUMP_VELOCITY / 2
	
	if Input.is_anything_pressed() == false and state != ATTACK:
		# không có nút nào được nhấn và trạng thái không phải là tấn công
		state = IDLE # trạng thái về mặt định
	
	match state:
		#kiểm tra các trạng thái để chạy các animation tương ứng
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
	
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_legde = was_on_floor and not is_on_floor() and velocity.y >=  0
	if just_left_legde:
		coyote_jump_time.start()

func run_state(direction):
	if direction:
		velocity.x = direction * SPEED
		#xoay nhân vật theo hướng di chuyển 
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
	# xoay hitbox người chơi theo hướng mặt nhân vật
	if $Sprite2D.flip_h:
		$pos.rotation_degrees = 180
	else:
		$pos.rotation_degrees = 360
	
	#đếm số lần đánh để chạy animation tương ứng = true => animation 1, false => animation 2
	if count_combo:
		animation.play("attack")
	elif !count_combo:
		animation.play("double_attack")

func _on_sword_hit_area_entered(area):
	pass
