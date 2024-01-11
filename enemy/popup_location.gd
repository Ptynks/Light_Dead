extends Marker2D

@export var damage_node : PackedScene

func popup(message):
	var damage = damage_node.instantiate()
	damage.position = global_position
	damage.get_child(0).text = str(message)
	
	get_tree().current_scene.add_child(damage)
