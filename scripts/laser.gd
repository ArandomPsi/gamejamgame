extends Node2D

func _process(delta):
	var tween = create_tween()
	var timer = get_tree().create_timer(0.2)
	tween.tween_property($Sprite2D,"modulate",Color(1,1,1,0), 0.2)
	await timer.timeout
	$Area2D/CollisionShape2D.disabled = false
	var tween2 = create_tween()
	tween2.tween_property($Sprite2D,"modulate",Color(1, 1, 1, 0), 0.2)
	
	
	
