extends Sprite

export var power = 0.05
export (NodePath) var termometer_node = null
onready var termometer = get_node(termometer_node)


func _on_Button_pressed():
	termometer.temperature += power