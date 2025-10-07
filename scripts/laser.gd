extends Node2D

#https://www.youtube.com/shorts/jx3fnrodoWQ

func _ready():
	var tween = create_tween()
	var timer = get_tree().create_timer(0.3)
	$Sprite2D.self_modulate = Color(1,1,1,1)
	tween.tween_property($Sprite2D,"modulate",Color(0.5,0.5,0.5,0.5), 0.1)
	tween.tween_property($Sprite2D,"modulate",Color(0.5,0.5,0.5,0), 0.1)
	await timer.timeout
	$Area2D/CollisionShape2D.disabled = false
	var tween2 = create_tween()
	$Sprite2D.self_modulate = Color(1, 0.29019609093666, 0.29019609093666)
	tween2.tween_property($Sprite2D,"modulate",Color(1, 1, 1, 1), 0.2)
	tween2.tween_property($Sprite2D,"modulate",Color(1, 1, 1, 0), 0.2)
	await tween2.finished
	queue_free()
	


func _on_area_2d_area_entered(area):
	var b = preload("res://scenes/explosion.tscn").instantiate()
	b.enemy = true
	b.modulate = Color(1,0.322,0.322)
	get_parent().add_child(b)
	b.position = area.global_position
	
	
