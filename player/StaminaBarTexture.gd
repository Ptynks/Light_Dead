extends TextureProgressBar

func _ready():
	update(100)

func update(stamina):
	value = stamina
