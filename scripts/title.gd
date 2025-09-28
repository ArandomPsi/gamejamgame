extends Control

func _ready():
	$transition.visible = true
	var tween = create_tween()
	tween.tween_property($transition,"scale",Vector2(0,1),0.5).set_trans(Tween.TRANS_CUBIC).set_delay(0.3)


func _on_play_pressed():
	var tween = create_tween()
	tween.tween_property($transition,"scale",Vector2(1,1),0.5).set_trans(Tween.TRANS_CUBIC).set_delay(0.3)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/testmap.tscn")


func _on_tutorial_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
