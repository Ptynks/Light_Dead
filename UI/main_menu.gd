extends Control

func _on_play_btn_pressed():
	get_tree().change_scene_to_file("res://world/world.tscn")


func _on_options_btn_pressed():
	pass # Replace with function body.


func _on_quit_btn_pressed():
	get_tree().quit()
