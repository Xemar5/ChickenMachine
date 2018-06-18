extends Sprite

var grav = 4.0
var xv = 0.0
var yv = 0.0
var rot = 0.0


func close():
	visible = false
	set_process(false)

func open():
	visible = true
	position.x = 0
	position.y = 0
	rotation = 0
	set_process(true)

	yv = rand_range(2, 3)
	xv = rand_range(-2, 2)
	rot = rand_range(-0.1, 0.1)

func _process(delta):
	global_position.x += xv
	global_position.y -= yv
	rotation += rot
	
	yv -= grav * delta
