extends Button
var nerftype = 0
var nerfamount = 0.9
var nerfs : Array = ["nerf speed", "nerf attack", "nerf hp", "nerf accuracy", "nerf shot amount", "nerf range", "nerf bullet speed", "nerf boomerang", "nerf double hit", "nerf aimbot","nerf firerate"]


func randomnerfs():
	nerftype = randi_range(0,10)
	nerfamount = randf_range(0.4,0.95)
	text = str(round(100 - (nerfamount * 100))) + "% " + nerfs[nerftype]
