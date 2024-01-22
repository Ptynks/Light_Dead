extends Node2D

@onready var boss = preload("res://enemy/maces_boss/maces_boss.tscn")

func boss_fighting(pos):
	var ins = boss.instantiate()
	ins.position = pos
	add_child(ins)

func _on_boss_area_body_entered(body):
	if body.name == "Player":
		boss_fighting(Vector2(0, 0))
		#.disabled = false
		#$BossWall/Sprite2D.visible = true
