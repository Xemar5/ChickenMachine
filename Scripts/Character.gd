extends Area2D

onready var good_image = get_node("CharacterGood")
onready var bad_image = get_node("Character")
export var character = ""
export var down = false setget , _get_down
func _get_down(): return down

func _ready():
	set_process_input(true)

func _input(event):
	if event is InputEventKey:
		var event_char = OS.get_scancode_string(event.scancode).to_upper()
		if event_char != character: return
		
		if event.pressed == true:
			set_down(true)
		else:
			set_down(false)

func set_down(value):
	down = value
	good_image.visible = value
	bad_image.visible = !value
