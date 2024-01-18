extends Node2D

var dust_effect = preload("res://effect/dust_effect.tscn")
var dust_effect_jump = preload("res://effect/dust_effect_jump.tscn")
@onready var player = $Player

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
