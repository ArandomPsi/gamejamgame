extends Node2D

func _ready():
	$GPUParticles2D.emitting = true
	for i in range(30):
		var b = preload("res://scenes/explosion.tscn").instantiate()
		b.explosion = true
		b.damage = 5
		b.position = position
		get_parent().add_child(b)
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
	$GPUParticles2D.emitting = false
	for i in range(3):
		var b = preload("res://scenes/explosion.tscn").instantiate()
		b.explosion = true
		b.damage = 5
		b.position = position
		get_parent().add_child(b)
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
	queue_free()
