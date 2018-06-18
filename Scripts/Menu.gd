extends Node

onready var manager = get_node("..")
export var play_stage_path = ""
export var credits_stage_path = ""

func start(): pass

func _on_play_pressed():
	manager.change_stage(play_stage_path)


func _on_credits_pressed():
	manager.change_stage(credits_stage_path)


func _on_exit_pressed():
	get_tree().quit()
