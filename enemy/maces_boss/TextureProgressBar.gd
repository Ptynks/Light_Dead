extends TextureProgressBar

func _ready():
	update(100)

func update(health):
	value = health
