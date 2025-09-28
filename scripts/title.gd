extends Control

func _ready():
	$transition.visible = true
	$tutorialmenu.scale = Vector2(0,0)
	var tween = create_tween()
	tween.tween_property($transition,"scale",Vector2(0,1),0.5).set_trans(Tween.TRANS_CUBIC).set_delay(0.3)


func _on_play_pressed():
	var tween = create_tween()
	tween.tween_property($transition,"scale",Vector2(1,1),0.5).set_trans(Tween.TRANS_CUBIC).set_delay(0.3)
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
