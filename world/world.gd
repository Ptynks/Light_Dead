extends Node2D

var dust_effect = preload("res://effect/dust_effect.tscn")
var dust_effect_jump = preload("res://effect/dust_effect_jump.tscn")
@onready var boss = preload("res://enemy/maces_boss/maces_boss.tscn")
@onready var player = $Player
var in_boss_fighting = false

func _physics_process(_delta):
	if Input.is_action_just_pressed("dash") and player.is_player_in_floor():
		var dust_ins = dust_effect.instantiate()
		add_child(dust_ins)
		dust_ins.position = $Player.position
		if $Player/Sprite2D.flip_h:
			dust_ins.scale.x = 1
		else:
			dust_ins.scale.x = -1 
	
	if Input.is_action_just_pressed("jump"):
		var dust_ins = dust_effect_jump.instantiate()
		add_child(dust_ins)
		dust_ins.position = $Player.position
	
	if in_boss_fighting:
		$floor/CollisionShape2D2.disabled = false
		$floor/CollisionShape2D2/Sprite2D.visible = true

func boss_fighting(pos):
	var ins = boss.instantiate()
	ins.position = pos
	add_child(ins)

func _on_boss_area_body_entered(body):
	if body.name == "Player":
		in_boss_fighting = true
		boss_fighting(Vector2(3455.071, 1140.504))
