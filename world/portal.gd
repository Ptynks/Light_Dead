extends RigidBody2D

var player_in = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and player_in:
		get_tree().change_scene_to_file("res://level/choose_spell_level.tscn")

func _on_hurt_box_body_entered(body):
	if body.name == "Player":
		player_in = true

func _on_hurt_box_body_exited(body):
	if body.name == "Player":
		player_in = false
