extends AnimatedSprite

var hatch_level = 0.0
export var hatch_speed = 0.1
export var reverse_hatch_speed = 0.3
var termometers = []
var lost = false
onready var upper_shell = get_node("EggUpper")
onready var angry = get_node("Angry")
export var done = false setget , _get_done
func _get_done(): return done

func change_state():
	if lost == true: return
	if hatch_level == 0:
		frame = 0
	elif hatch_level < 1.0 / 6.0:
		frame = 1
	elif hatch_level < 2.0 / 6.0:
		frame = 2
	elif hatch_level < 3.0 / 6.0:
		frame = 3
	elif hatch_level < 4.0 / 6.0:
		frame = 4
	elif hatch_level < 5.0 / 6.0:
		frame = 5
	else:
		frame = 6

func _ready():
	termometers = []
	set_process(true)
	get_termometers(get_tree().get_root())
	upper_shell.visible = false

func _process(delta):
	if done == true: return
	if lost == true:
		angry.rotation = angry.rotation * 0.9
		return
	
	var good = true
	for item in termometers:
		if item.done == false:
			good = false
	
	if good == true:
		hatch_level += hatch_speed * delta
		if hatch_level > 1: hatch_level = 1
		change_state()
		if frame == 6:
			done = true
			upper_shell.open()
	elif hatch_level > 0:
		hatch_level -= reverse_hatch_speed * delta
		if hatch_level < 0: hatch_level = 0
		change_state()


func get_termometers(node):
	if node == null: return
	if "temperature" in node:
		termometers.append(node)
		print("found termometers: ", str(termometers.size()))
	
	if node.get_child_count() == 0: return
	for child in node.get_children():
		get_termometers(child)

func is_hatching():
	var good = true
	for item in termometers:
		if item.done == false:
			good = false
	return good

func angry():
	if lost == true: return
	if done == true: return
	lost = true
	angry.visible = true
	angry.rotation = PI / 2.0
