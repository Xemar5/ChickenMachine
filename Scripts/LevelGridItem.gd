extends CenterContainer

export var label_text = ""
export var level_path = ""
var enabled setget _set_enabled, _get_enabled
onready var label = get_node("TextureRect/Label")
onready var button = get_node("TextureRect")
onready var manager = get_tree().get_root().get_node("StageManager")

func _set_enabled(value):
	enabled = value
	if button != null:
		change_enabled(value)
	

func _get_enabled(): return enabled

func _ready():
	label.set_text(label_text)
	if button.enabled != enabled:
		change_enabled(enabled)

func change_enabled(value):
	button.enabled = value
	if value == false:
		button.modulate.r = 0.5
		button.modulate.g = 0.5
		button.modulate.b = 0.5
	else:
		button.modulate.r = 1
		button.modulate.g = 1
		button.modulate.b = 1
		
	pass

func _on_TextureRect_pressed():
	manager.change_stage(level_path)
