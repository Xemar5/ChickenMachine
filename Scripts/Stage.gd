extends Position2D

onready var manager = get_tree().get_root().get_node("StageManager")
onready var stage_index = get_stage_index()
onready var level_select = "res://Scenes/LevelSelector.tscn"
onready var timer = get_node("Timer")
onready var back_arrow = get_node("Arrow")
var eggs = []
var ended = false

func get_win():
	var win = true
	for egg in eggs:
		if egg.done == false:
			win = false
	return win

func _ready():
	set_process(false)
	get_eggs(self)
	manager.play_woah()
	print(self.name)

func start(): 
	timer.start()
	set_process(true)


func _process(delta):
	if ended == true: return
	
	var win = get_win()
	var lost = timer.ended
	var hatching = true
	for egg in eggs:
		if egg.is_hatching() == false:
			hatching = false
	if hatching == true:
		timer.pause()
	else:
		timer.start()
	
	if win == true:
		ended = true
		stage_ended(true)
	elif lost == true:
		ended = true
		for egg in eggs:
			egg.angry()
		stage_ended(false)

func stage_ended(win):
	if win == true:
		var lvl = manager.read_data()
		if lvl <= stage_index:
			manager.write_data(stage_index + 1)
	
	if win == true:
		manager.play_applause()
	else:
		manager.play_boo()
	
	back_arrow.modulate.r = 0.5 if win == true else 1
	back_arrow.modulate.g = 1 if win == true else 0.5
	back_arrow.modulate.b = 0.5

func get_eggs(node):
	if node == null: return
	if "hatch_speed" in node:
		eggs.append(node)
		print("found eggs: ", str(eggs.size()))
	
	if node.get_child_count() == 0: return
	for child in node.get_children():
		get_eggs(child)

func get_stage_index():
	var dir = Directory.new()
	dir.open("res://Scenes/Stages")
	dir.list_dir_begin()
	var i = 0
	var file_name = dir.get_next()
	var lvl = manager.read_data() + 1
	while file_name != "":
		if file_name == name + ".tscn":
			return i
		elif file_name != "." and file_name != "..":
			i += 1
		file_name = dir.get_next()
	return -1

func _on_back_pressed():
	manager.change_stage(level_select)
