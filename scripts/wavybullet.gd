extends Node2D

@export var brange : int = 300
@export var bulletspeed : int = 500
@export var bigboi : bool = true

var bullettime : int = 0

var time: float = 0.0
@export var frequency: float = 5.0  # how fast it waves side to side
@export var amplitude: float = 750.0  # how far it moves side to side


func _process(delta):
	bullettime += 1
	$Sprite2D.rotation_degrees += 8
	
	time += delta
	
	# Move forward normally
	var forward_movement = transform.x * bulletspeed * delta
	
	# Calculate side-to-side offset using sine wave
	var side_offset = Vector2(transform.y.x, transform.y.y) * sin(time * frequency) * amplitude * delta
	global_position += forward_movement + side_offset

	
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


func _on_area_2d_2_area_entered(area):
	pass
