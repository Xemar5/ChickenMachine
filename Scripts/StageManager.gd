extends Node

export var starting_stage = ""
onready var hand_front = load("res://Scenes/HandFront.tscn")
onready var hand_back = load("res://Scenes/HandBack.tscn")
onready var beg = ProjectSettings.get_setting("display/window/size/height")
onready var player_applause = get_node("AudioStreamPlayerApplause")
onready var player_woah = get_node("AudioStreamPlayerWoah")
onready var player_boo = get_node("AudioStreamPlayerBoo")
onready var player_music = get_node("AudioStreamPlayerMusic")
onready var player_click1 = get_node("AudioStreamPlayerClick1")
onready var player_click2 = get_node("AudioStreamPlayerClick2")
var current = null
var coroutines = {}
var indexer = 0
var speed = 0.6

func _ready():
	change_stage(starting_stage)
	set_process(true)

func is_current(stage):
	while stage != null:
		if stage == current: return true
		stage = stage.get_parent()
	return false

func change_stage(path):
	if current != null:
		var temp = current
		current = null
		remove_previous(temp)
	change_position(path)

func change_position(path):
	var package = load("res://Scripts/ChangePackage.gd").new()
	package.hand_front = hand_front.instance()
	package.hand_back = hand_back.instance()
	package.stage = load(path).instance()
	package.index = indexer
	
	add_child(package.hand_back)
	add_child(package.stage)
	add_child(package.hand_front)
	move_child(package.hand_back, get_child_count())
	move_child(package.stage, get_child_count())
	move_child(package.hand_front, get_child_count())

	
	package.hand_front.position.y = beg
	package.hand_back.position.y = beg	
	package.stage.position.y = beg
	
	coroutines[indexer] = package
	indexer += 1
	package.coroutine = change_position_process(package)

func change_position_process(package):
	while package.stage.position.y > 0.1:
		package.stage.position.y *= speed
		package.hand_front.position.y *= speed
		package.hand_back.position.y *= speed
		yield(get_tree(), "idle_frame")
		
	package.stage.position.y = 0
	package.hand_front.position.y = 0
	package.hand_back.position.y = 0
	coroutines.erase(package.index)
	
	current = package.stage
	current.start()
	
	package.coroutine = hide_hands(package)
	package.index = indexer
	coroutines[indexer] = package
	indexer += 1

func hide_hands(package):
	package.hand_front.position.y = 1
	package.hand_back.position.y = 1
	while package.hand_front.position.y < beg:
		package.hand_front.position.y /= speed
		package.hand_back.position.y /= speed
		yield(get_tree(), "idle_frame")
	
	remove_child(package.hand_front)
	remove_child(package.hand_back)
	coroutines.erase(package.index)

func remove_previous(stage):
	var package = load("res://Scripts/ChangePackage.gd").new()
	package.stage = stage
	package.index = indexer
	
	coroutines[indexer] = package
	indexer += 1
	package.coroutine = remove_previous_process(package)


func remove_previous_process(package):
	package.stage.global_position.y = 1
	while package.stage.position.y < beg:
		package.stage.global_position.y *= 1.3
		yield(get_tree(), "idle_frame")
	remove_child(package.stage)
	coroutines.erase(package.index)	



func _process(delta):
	for c in coroutines.values():
		c.coroutine.resume()




func read_data():
	var file = File.new()
	file.open("user://savegame.save", File.READ)
	if file.is_open():
		return file.get_32()
	else:
		return 0

func write_data(lvl):
	var file = File.new()
	file.open("user://savegame.save", File.WRITE)
	if file.is_open():
		file.store_32(lvl)

func play_applause(): player_applause.play(0)
func play_woah(): player_woah.play(0)
func play_boo(): player_boo.play(0)
func play_click():
	return
	var rand = randi() % 2
	if rand == 0:
		player_click1.play(0)
	else:
		player_click2.play(0)


func _on_music_finished():
	player_music.play(0)
