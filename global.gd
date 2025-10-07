extends Node

var playerpos : Vector2
var playervelocity : Vector2
var playerhp : int = 5

var highscore : int = 0

var save_path := "user://Zer0-SumHS.save"

var bosspos : Vector2

var sounds : bool = true
var fog : bool = true
var motionblur : bool = true
var ezhp : bool = false
var noise : bool = true

func _process(delta):
	AudioServer.set_bus_mute(0,not sounds)

func save_highscore():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var data = {
		"highscore": highscore
	}
	file.store_string(JSON.stringify(data))
	file.close()

func load_highscore():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		if typeof(data) == TYPE_DICTIONARY and data.has("highscore"):
			highscore = data["highscore"]
		file.close()
