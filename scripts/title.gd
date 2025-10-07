extends Control

func _ready():
	global.load_highscore()
	if global.highscore > 0:
		$highscore.text = "high score - " + str(global.highscore)
		$highscore.visible = true
	else:
		$highscore.visible = false
	$AudioStreamPlayer.volume_db
	$transition.visible = true
	$tutorialmenu.scale = Vector2(0,0)
	$tutorialmenu.visible = true
	var tween = create_tween()
	tween.tween_property($transition,"scale",Vector2(0,1),0.5).set_trans(Tween.TRANS_CUBIC).set_delay(0.3)
	tween.parallel().tween_property($AudioStreamPlayer,"volume_db",0,0.5).set_trans(Tween.TRANS_CUBIC)

func _process(delta):
	$tutorialmenu/motionblurbutton.button_pressed = global.motionblur
	$tutorialmenu/fogbutton.button_pressed = global.fog
	$tutorialmenu/ezhp.button_pressed = global.ezhp
	$tutorialmenu/musictoggle.button_pressed = global.sounds
	$tutorialmenu/ezhp2.button_pressed = global.noise

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
	global.save_highscore()

func tutorialappear():
	var tween = create_tween()
	$tutorialmenu/Panel/RichTextLabel.visible = true
	tween.tween_property($tutorialmenu,"scale", Vector2(1,0.01),0.4).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($tutorialmenu,"scale", Vector2(1,1),0.4).set_delay(0.3).set_trans(Tween.TRANS_CUBIC)

func tutorialdissapear():
	var tween = create_tween()
	tween.tween_property($tutorialmenu,"scale", Vector2(1,0.01),0.4).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($tutorialmenu,"scale", Vector2(0,0),0.4).set_delay(0.1).set_trans(Tween.TRANS_CUBIC)
	$tutorialmenu/Panel/RichTextLabel.visible = true


func _on_reset_pressed():
	global.highscore = 0
	global.save_highscore()


func _on_motionblurbutton_pressed():
	global.motionblur = not global.motionblur


func _on_fogbutton_pressed():
	global.fog = not global.fog


func _on_musictoggle_pressed():
	global.sounds = not global.sounds


func _on_ezhp_pressed():
	global.ezhp = not global.ezhp


func _on_ezhp_2_pressed():
	global.noise = not global.noise
