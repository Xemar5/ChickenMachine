extends Node

signal pressed
var upscale = 1.05
var downscale = 0.95
var default_scale = 1.0
var inside = false
var enabled = true
onready var manager = get_tree().get_root().get_node("StageManager")

func _ready():
	if self is Control:
		default_scale = self.rect_scale.x
	elif self is Node2D:
		default_scale = self.scale.x
	set_scale(default_scale)

func press():
	if manager.is_current(self) == true:
		manager.play_click()
		emit_signal("pressed")

func _on_mouse_entered():
	if enabled == false: return
	set_scale(default_scale * upscale)
	inside = true


func _on_mouse_exited():
	if enabled == false: return
	set_scale(default_scale)
	inside = false

func _on_input_event(viewport, event, shape_idx):
	if enabled == false: return
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			set_scale(default_scale * downscale)
		else:
			if inside == true:
				press()
				set_scale(default_scale * upscale)
			else:
				set_scale(default_scale)

func _on_gui_input(event):
	_on_input_event(null, event, null)

func set_scale(value):
	if self is Control:
		self.rect_scale.x = value
		self.rect_scale.y = value
	elif self is Node2D:
		self.scale.x = value
		self.scale.y = value

