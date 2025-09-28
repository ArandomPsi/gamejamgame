extends Control

func _ready():
	if global.highscore > 0:
		$highscore.text = "high score - " + str(global.highscore)
	else:
		$highscore.visible = false
	$AudioStreamPlayer.volume_db
	$transition.visible = true
	$tutorialmenu.scale = Vector2(0,0)
	$tutorialmenu.visible = true
	var tween = create_tween()
	tween.tween_property($transition,"scale",Vector2(0,1),0.5).set_trans(Tween.TRANS_CUBIC).set_delay(0.3)
	tween.parallel().tween_property($AudioStreamPlayer,"volume_db",0,0.5).set_trans(Tween.TRANS_CUBIC)

func _on_play_pressed():
	var tween = create_tween()
	tween.tween_property($transition,"scale",Vector2(1,1),0.5).set_trans(Tween.TRANS_CUBIC).set_delay(0.3)
	tween.parallel().tween_property($AudioStreamPlayer,"volume_db",-80,0.5).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/testmap.tscn")


func _on_tutorial_pressed():
	tutorialappear()


func _on_quit_pressed():
	get_tree().quit()

func tutorialappear():
	var tween = create_tween()
	$tutorialmenu/RichTextLabel.visible = true
	tween.tween_property($tutorialmenu,"scale", Vector2(1,0.01),0.4).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($tutorialmenu,"scale", Vector2(1,1),0.4).set_delay(0.3).set_trans(Tween.TRANS_CUBIC)

func tutorialdissapear():
	var tween = create_tween()
	tween.tween_property($tutorialmenu,"scale", Vector2(1,0.01),0.4).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($tutorialmenu,"scale", Vector2(0,0),0.4).set_delay(0.1).set_trans(Tween.TRANS_CUBIC)
	$tutorialmenu/RichTextLabel.visible = false
