extends Node2D

var loadthing : Array = ["Loading","Loading.","Loading..","Loading..."]
var loadphase : int = 0
var time : int = 0

func _process(delta):
	time += 1
	if time > 20:
		loadphase += 1
		if loadphase > 3:
			loadphase = 0
		$Label.text = loadthing[loadphase]
		time = 0

func thing():
	get_tree().change_scene_to_file("res://scenes/title.tscn")
