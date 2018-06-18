extends Sprite

export var word = "word"
export var power = 0.3
export (NodePath) var termometer_node = null
export var width = 250.0
export var max_interval = 60
export var min_interval = 30
onready var termometer = get_node(termometer_node)
var list = []
var characters = []

func _ready():
	set_process(true)
	for c in word.to_upper():
		list.append(c)
	create_placeholders()

func create_placeholders():
	if list.size() == 0: return
	var char_scene = load("res://Scenes/Components/Character.tscn")
	var size = float(list.size() - 1)
	var interval = width / size if size > 0.0 else 0.0
	if interval > max_interval: interval = max_interval
	if interval < min_interval: interval = min_interval
	var beg = - interval * size / 2.0
	print(size, ", ", beg, ", ", interval)
	for c in list:
		var char_instance = char_scene.instance()
		char_instance.set_name("Char " + str(c))
		char_instance.position.x = beg
		char_instance.character = c
		add_child(char_instance)
		
		var label = char_instance.get_node("Label")
		label.set_text(str(c))
		beg += interval
		characters.append(char_instance)

func _process(delta):
	var good = true
	for c in characters:
		if c.down == false:
			good = false
	if good == false: return
	termometer.temperature += power * delta
