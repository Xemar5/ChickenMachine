extends Position2D

var time = 0.0
export var starting_time = 15.0
onready var stage = get_node("..")
onready var timer = get_node("Label")
var ended = false
var paused = true

func _ready():
	time = starting_time
	timer.set_text(str(time))
	pause()

func start():
	if paused == false: return
	set_process(true)
	paused = false
	
func pause():
	if paused == true: return
	set_process(false)
	paused = true
	
func reset():
	time = starting_time

func _process(delta):
	if ended == true : return
	if paused == true: return
	time -= delta
	
	if time <= 0:
		time = 0
		timer.set_text("%.1f" % time)
		ended = true
	else:
		timer.set_text("%.1f" %  time)
		
