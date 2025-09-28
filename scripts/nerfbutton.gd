extends Button
var nerftype = 0
var nerfamount = 0.9
var nerfs : Array = ["nerf speed", "nerf attack", "nerf hp", "stormtrooper dna", "nerf amount of shots", "nerf range", "nerf bullet speed"]


func randomnerfs():
	nerftype = randi_range(0,6)
	nerfamount = randf_range(0.6,0.95)
	text = str(round(100 - (nerfamount * 100))) + "% " + nerfs[nerftype]
