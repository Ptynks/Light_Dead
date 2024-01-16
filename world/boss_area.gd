extends Area2D

@onready var boss = preload("res://enemy/maces_boss/maces_boss.tscn")

func _on_body_entered(body):
	if body.name == "Player":
		boss_fighting(Vector2(3455.071, 1140.504))

func boss_fighting(pos):
	var ins = boss.instantiate()
	ins.position = pos
	add_child(ins)
