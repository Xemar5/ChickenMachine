extends Node

onready var marker = get_node("Marker")
onready var upper_marker = get_node("UpperThreshold")
onready var lower_marker = get_node("LowerThreshold")
onready var upper_good_marker = get_node("UpperThresholdGood")
onready var lower_good_marker = get_node("LowerThresholdGood")

var height = 320
export var upper_threshold = 0.6
export var lower_threshold = 0.4
export var decay = 0.996
export var temperature = 0.0 setget _set_temp, _get_temp
func _get_temp(): return temperature
func _set_temp(value): 
	temperature = value
	transform_marker()
	recolor_thresholds()
export var done = false setget , _get_done
func _get_done(): return done


func transform_marker():
	if marker != null :
		if temperature < 0.0: temperature = 0.0
		if temperature > 1.0: temperature = 1.0
		marker.position.y = -temperature * height + height / 2

func transform_thresholds():
	upper_marker.position.y = -upper_threshold * height + height / 2
	lower_marker.position.y = -lower_threshold * height + height / 2
	upper_good_marker.position.y = -upper_threshold * height + height / 2
	lower_good_marker.position.y = -lower_threshold * height + height / 2

func recolor_thresholds():
	if upper_marker == null: return
	if temperature >= lower_threshold and temperature <= upper_threshold:
		upper_marker.visible = false
		lower_marker.visible = false
		upper_good_marker.visible = true
		lower_good_marker.visible = true
		done = true
	else:
		upper_marker.visible = true
		lower_marker.visible = true
		upper_good_marker.visible = false
		lower_good_marker.visible = false
		done = false

func _ready():
	transform_thresholds()
	set_process(true)

func _process(delta):
	_set_temp(temperature * decay)

