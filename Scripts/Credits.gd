extends Position2D

onready var manager = get_node("..")
export var main_menu_path = ""

func start(): pass

func _on_back_pressed():
	manager.change_stage(main_menu_path)


func _on_reset_pressed():
	manager.write_data(0)
