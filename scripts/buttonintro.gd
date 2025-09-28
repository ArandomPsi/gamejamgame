extends Button
@export var delay : float = 0.5


func _ready():
	scale.x = 0
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1),0.5).set_delay(delay).set_trans(Tween.TRANS_CUBIC)
