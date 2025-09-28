extends Node2D

var bullettime : int = 0
var bulletrange : int = 75
var bulletspeed : int = 1200


func _process(delta):
	$Sprite2D.rotation_degrees += 18
	bullettime += 1
	
	
	position += bulletspeed * transform.x * delta
	
	if bullettime > bulletrange:
		twintowers()
	


func twintowers():
	var b = preload("res://scenes/slashes.tscn").instantiate()
	get_parent().add_child(b)
	b.position = position
	queue_free()

func _on_area_2d_area_entered(area):
	twintowers()
