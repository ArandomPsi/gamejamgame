extends Node2D

func _ready():
	$Sprite2D.visible = true
	modulate = Color(1,1,1,0)
	var tween = create_tween()
	tween.tween_property(self,"modulate", Color(1,1,1,1),0.2).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"modulate", Color(1,1,1,0),0.2).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	var b = preload("res://scenes/explosion.tscn").instantiate()
	b.enemy = true
	b.explosion = true
	b.modulate = Color(1,0.5,0.5)
	b.position = position
	get_parent().add_child(b)
	queue_free()
