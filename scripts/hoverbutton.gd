extends Button

var aimscale = 0.4

func _process(delta):
	scale = lerp(scale,Vector2(aimscale,aimscale), 0.8)


func _on_mouse_entered():
	aimscale = 0.45


func _on_mouse_exited():
	aimscale = 0.4
