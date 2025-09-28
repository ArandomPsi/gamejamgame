extends Node2D
var fire : bool = false
var explosion : bool = false
var enemy : bool = false
var damage = 1

func _ready():
	var tween = create_tween()
	var sc = 0.2
	#collisions
	if explosion: sc = 0.5
	if enemy: $Sprite2D/Area2D.set_collision_mask_value(2,true)
	else: $Sprite2D/Area2D.set_collision_mask_value(3,true)
	tween.tween_property($Sprite2D,"scale",Vector2(sc,sc),0.2)
	tween.parallel().tween_property($Sprite2D,"modulate",Color(1,1,1,0),0.2)
	await tween.finished
	if fire:
		var b = preload("res://scenes/explosion.tscn").instantiate()
		b.damage = damage * 2
		b.explosion = true
		get_parent().add_child(b)
		b.position = position
		
	queue_free()


func _on_area_2d_area_entered(area):
	area.get_parent().take_damage(damage)
	$AudioStreamPlayer2D.pitch_scale = randf_range(0.9,1.2)
	$AudioStreamPlayer2D.play()
