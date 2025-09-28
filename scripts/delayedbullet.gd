extends Node2D

var brange : int = 140
var bulletspeed : int = 700

var bullettime : int = 0
var targetagain : bool = true

func _process(delta):
	bullettime += 1
	
	#normalmovement
	
	if bullettime < brange/2:
		bulletspeed *= 0.97
	elif bullettime == brange/2 and targetagain:
		look_at(global.playerpos)
	else:
		bulletspeed += 20
	
	position += transform.x * bulletspeed * delta
	
	if bullettime > brange:
		twintowers()
	

func twintowers():
	var b = preload("res://scenes/explosion.tscn").instantiate()
	b.explosion = false #big bullet exclusive
	b.enemy = true
	b.modulate = Color(1,0.322,0.322)
	get_parent().add_child(b)
	b.position = position
	queue_free()


func _on_area_2d_area_entered(area):
	twintowers()
