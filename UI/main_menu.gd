extends Control

var array = ["play", "options", "quit"]
var pos = [347, 429, 513]
var num = 0

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		match array[num]:
			"play": 
				get_tree().change_scene_to_file("res://world/world.tscn")
			"options":
				get_tree().change_scene_to_file("res://UI/options.tscn")
			"quit":
				get_tree().quit()
	
	if Input.is_action_just_pressed("ui_up"):
		num -= 1
		if num < 0:
			num = 2
	
	if Input.is_action_just_pressed("ui_down"):
		num += 1
		if num > 2:
			num = 0
	
	$Arrow.position.y = pos[num]

func _on_play_btn_pressed():
	get_tree().change_scene_to_file("res://world/world.tscn")


func _on_options_btn_pressed():
	get_tree().change_scene_to_file("res://UI/options.tscn")


func _on_quit_btn_pressed():
	get_tree().quit()
