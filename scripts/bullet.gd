extends Node2D
#SO FUCKING HARD I HAVE TO MAKE IT SOO MODULAR
var fbullets : bool = false
var ebullets : bool = false
var bbullets : bool = false
var brange : int = 120
var attack : int = 1
var bulletspeed : int = 700

var bullettime : int = 0

func _ready():
	if bbullets:
		brange *= 3 #for boomerangs

func _process(delta):
	bullettime += 1
	
	if bbullets:
		$Sprite2D.rotation_degrees += 15
		bulletspeed -= 7
	
	
	position += bulletspeed * transform.x * delta
	
	if bullettime > brange:
		twintowers()
	
	

func twintowers():
	var b = preload("res://scenes/explosion.tscn").instantiate()
	b.explosion = ebullets
	b.fire = fbullets
	b.damage = attack
	get_parent().add_child(b)
	b.position = position
	queue_free()

func _on_area_2d_area_entered(area):
	if bbullets:
		if bullettime > brange/2:
			twintowers()
		else:
			if area.get_parent().has_method("take_damage"):
				area.get_parent().take_damage(attack)
	else:
		twintowers()
