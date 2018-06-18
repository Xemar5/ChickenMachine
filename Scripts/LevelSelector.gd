extends Node

export var main_menu_path = ""
onready var manager = get_node("..")
onready var container = get_node("ScrollContainer/MarginContainer/GridContainer")

func start(): pass


func _ready():
	var dir = Directory.new()
	dir.open("res://Scenes/Stages")
	dir.list_dir_begin()
	var i = 1
	var file_name = dir.get_next()
	var lvl = manager.read_data() + 1
	while file_name != "":
		if file_name != "." and file_name != "..":
			var item = load("res://Scenes/LevelGridItem.tscn").instance()
			item.level_path = "res://Scenes/Stages/" + file_name
			item.label_text = str(i)
			item.enabled = i <= lvl
			container.add_child(item)
			i += 1
		file_name = dir.get_next()



func _on_back_pressed():
	manager.change_stage(main_menu_path)
