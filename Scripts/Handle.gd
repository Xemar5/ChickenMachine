extends Node

var is_holding = false
var starting_angle = 0.0
var handle = null
export var max_speed = 0.1
export var ratio = 0.04
export (NodePath) var termometer_node = null
onready var termometer = get_node(termometer_node)

export var value = 0.0 setget _set_value, _get_value
func _set_value(v):
	value = v
	if termometer != null:
		termometer.temperature += value * ratio
func _get_value(): return value


func _ready():
	handle = get_node("Handle")
	set_process(true)
	set_process_input(true)
	pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed == false and is_holding == true:
			value = 0.0
			is_holding = false

func _process(delta):
	if is_holding:
		var mouse_pos = get_viewport().get_mouse_position()
		var pos = handle.global_position
		var ang = atan2(mouse_pos.x - pos.x, mouse_pos.y - pos.y)
		
		var ang_delta = starting_angle - ang
		if ang_delta > PI: ang_delta -= 2 * PI
		if ang_delta < -PI: ang_delta += 2 * PI
		
		if ang_delta > max_speed: ang_delta = max_speed
		if ang_delta < -max_speed: ang_delta = -max_speed
		
		_set_value(ang_delta)
		handle.rotation += ang_delta
		starting_angle -= ang_delta
		
		if starting_angle > 2 * PI: starting_angle -= 4 * PI
		if starting_angle < 2 * -PI: starting_angle += 4 * PI
	else: _set_value(0.0)


func _on_handle_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			var mouse_pos = get_viewport().get_mouse_position()
			var pos = handle.global_position
			starting_angle = atan2(mouse_pos.x - pos.x, mouse_pos.y - pos.y)
			is_holding = true
