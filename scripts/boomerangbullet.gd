extends Node2D

@export var brange : int = 120
@export var bulletspeed : int = 700
@export var bigboi : bool = true

var bullettime : int = 0

var time: float = 0.0
@export var frequency: float = 10.0  # how fast it waves side to side
@export var amplitude: float = 750.0  # how far it moves side to side

var grouprotation : int = 0

func _process(delta):
	bullettime += 1
	
	position += transform.x * bulletspeed * delta
	
	bulletspeed = clamp(bulletspeed,-1000,10000)
	
	
	bulletspeed -= 15
	
	$Sprite2D.rotation_degrees += 14
	
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


func _on_area_2d_2_area_entered(area):
	if bullettime < brange/2:
		rotation_degrees += 180
		rotation_degrees += grouprotation
