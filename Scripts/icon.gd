extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	set_process_input(true)
	pass

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_W:
			position.y += 10
		if event.scancode == KEY_S:
			position.y -= 10
		if event.scancode == KEY_A:
			position.x -= 10
		if event.scancode == KEY_D:
			position.x += 10
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
