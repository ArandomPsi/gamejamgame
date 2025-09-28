extends Node2D

@export var brange : int = 120
@export var bulletspeed : int = 700
@export var bigboi : bool = true

var bullettime : int = 0


func _process(delta):
	bullettime += 1
	$Sprite2D.rotation_degrees += 8
	
	#normalmovement
	position += transform.x * bulletspeed * delta
	
	if bullettime > brange:
		twintowers()
	

func twintowers():
	var b = preload("res://scenes/explosion.tscn").instantiate()
	if bigboi:
		b.explosion = true #big bullet exclusive
	b.enemy = true
	b.modulate = Color(1,0.322,0.322)
	get_parent().add_child(b)
	b.position = position
	queue_free()


func _on_area_2d_area_entered(area):
	twintowers()
