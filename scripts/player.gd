extends Node2D

var velocity : Vector2

var canshoot : bool = false

var camerashake : int = 0
var flashalpha = 1

var buffs : Array = ["more caffine", "more attack", "more bodyfat", "more accuracy", "i need more boulets", "more range", "more bullet caffine", "boomerang boulets", "boom boom", "so fire"]

var iframes : int = 0
var iframealpha : float = 0
var iframetime : float = 0

var bossesslain : int = 0

var time : float = 0.0
var score: float = 0
var end: bool = false
var stop: bool = false
var multiplier: float = 1.0
var hitless : bool = true


#stats
var speed : int = 150
var atk : int = 5
var hp : int = 5
var maxhp : int = 5

var shotspeed : int = 0.05
var shotspread : float = 0
var shotamount : int = 1

var firebullets : bool = false
var explodingbullets : bool = false
var boomerangbullets : bool = false
var bulletrange : int = 75
var bulletspeed : int = 700

#debuffs
var maxnerf : int = 6
var nerfseverity : float = 0.9

var poison : int = 0

func _ready():
	$hud/flash.visible = true
	var tween = create_tween()
	tween.tween_property($hud/transition,"scale",Vector2(0,1),0.5).set_trans(Tween.TRANS_CUBIC)

func _physics_process(delta):
	camerashake -= 1
	iframes -= 1
	iframetime += delta
	if not $cutscenes.is_playing():
		controls()
	updatepos(delta)
	
	$Camera2D.offset = Vector2.ZERO
	if camerashake >= 1:
		var camshakeamount = camerashake * 1.2
		$Camera2D.offset += Vector2(randf_range(-camshakeamount,camshakeamount),randf_range(-camshakeamount,camshakeamount))
	
	#update health
	$player.max_value = maxhp
	$player.value = hp
	
	#flash
	$hud/flash.modulate = Color(1,1,1,flashalpha)
	flashalpha *= 0.8
	
	iframealpha = sin(iframetime * 50)
	if iframes > 1:
		$player.modulate = Color(1+iframealpha,1+iframealpha,1+iframealpha, 1)
	else:
		$player.modulate = Color(1,1,1,1)
	
	#calculate the score
	calcscore(delta)
	$hud/score.text = "score - " + str(score)
	#for hitless
	get_parent().get_child(1).visible = hitless
	
	global.playerpos = position
	global.playerhp = hp
	

#yada yada
func controls():
	var movedir : Vector2
	movedir = Input.get_vector("left","right","up","down")
	
	$pivot.look_at(get_global_mouse_position())
	
	#update vel
	velocity += movedir.normalized() * speed
	
	if Input.is_action_pressed("shoot") and canshoot:
		canshoot = false
		$shotcooldown.start(shotspeed)
		shoot()
	
	if Input.is_action_just_pressed("supershot") and hp > 0:
		canshoot = false
		$shotcooldown.start(shotspeed)
		velocity = $pivot.transform.x * -2000
		flashalpha = 1
		camerashake = 10
		$hud/flash.color = Color(0.93000000715256, 0.84490501880646, 0.36269998550415)
		supershoot()
		hp -= 1
	
	
	if Input.is_action_just_pressed("debug"):
		take_damage(1)
	
	if Input.is_action_just_pressed("debug2"):
		nerfsappear()
	

func updatepos(delta):
	
	$aura.rotation_degrees += 4
	
	#the vel stuff to replace move and slide
	velocity *= 0.75
	position += velocity * delta
	position.x = clamp(position.x,0,1152)
	position.y = clamp(position.y,0,648)

func shoot():
	for i in range(shotamount): #for the shotgun
		var b = preload("res://scenes/bullet.tscn").instantiate()
		#all the stats for the bullet
		b.fbullets = firebullets
		b.brange = bulletrange
		b.bulletspeed = bulletspeed
		b.ebullets = explodingbullets
		b.bbullets = boomerangbullets #The best bullet type lol
		b.attack = atk
		#what you need
		get_parent().add_child(b)
		
		b.position = position
		b.look_at(get_global_mouse_position())
		b.rotation_degrees += randf_range(-shotspread,shotspread)
		b.position += b.transform.x * $pivot/Aimarrow.offset.x
	
	shoteffect()
	camerashake = 2
	

func supershoot():
	var b = preload("res://scenes/supershot.tscn").instantiate()
	get_parent().add_child(b)
	b.position = position
	b.look_at(get_global_mouse_position())
	b.position += b.transform.x * 80

func shoteffect():
	var b = preload("res://scenes/shoteffect.tscn").instantiate()
	get_parent().add_child(b)
	b.position = position
	b.look_at(get_global_mouse_position())
	b.position += $pivot/Aimarrow.offset.x * b.transform.x

func calcscore(delta):
	time += delta * 1.25
	multiplier = (bossesslain + 1) / 2
	if stop:
		return
	if hitless:
		multiplier *= 1.5
	print(time)
	if time >= 3:
		end = true
	if end && not stop:
		score = round_to_hths(41250000 * multiplier / time)
		print(score)
		stop = true

func round_to_hths(num): # rounds to nearest hundredths place
	return round(pow(10, 2) * num) / 100

func take_damage(damage):
	if iframes < 1:
		iframes = 30
		hitless = false
		hp -= damage
		camerashake = 20
		$hud/flash.visible = true
		$hud/flash.color = Color(1,1,1,1)
		flashalpha = 1
		if hp < 0:
			iframes = 500
			die()
	

func die():
	$cutscenes.play("diecutscene")

func diefr():
	var tween = create_tween()
	tween.tween_property($hud/transition,"scale",Vector2(1,1),0.5).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/title.tscn")

func nerf(type : int, decrease : float):
	if type == 0: #speed nerf
		speed *= decrease
	elif type == 1: #damage nerf
		atk *= decrease
	elif type == 2: #hp nerf
		maxhp *= decrease
	elif type == 3: #spread nerf
		shotspread += 10
	elif type == 4: #shotamount nerf
		shotamount *= decrease
		shotamount = clamp(shotamount,1,300)
	elif type == 5: #range nerf
		bulletrange *= decrease
	elif type == 6: #bullet speed nerf
		bulletspeed *= decrease
	

func buff(type : int):
	if type == 0: #speed buff
		speed /= nerfseverity
	elif type == 1: #damage buff
		atk /= nerfseverity
	elif type == 2: #hp buff
		maxhp /= nerfseverity
	elif type == 3: #spread buff
		shotspread *= nerfseverity
	elif type == 4: #shotamount buff
		shotamount *= 2
	elif type == 5: #range buff
		bulletrange /= nerfseverity
	elif type == 6: #bullet speed buff
		bulletspeed /= nerfseverity
	elif type == 7: #bullet speed buff
		boomerangbullets = true
	elif type == 8: #bullet speed buff
		explodingbullets = true
	elif type == 9: #bullet speed buff
		firebullets = true

func nerfsappear():
	score += round_to_hths(41250000 * multiplier / time)
	$hud/nerfs.visible = true
	$hud/nerfs/nerf1.randomnerfs()
	$hud/nerfs/nerf2.randomnerfs()
	$hud/nerfs/nerf3.randomnerfs()
	var tween = create_tween()
	tween.tween_method(nerfmaterialmodify,0.0,1.0,0.5)

func nerfsdissapear():
	var tween = create_tween()
	$hud/flash.color = Color(1, 0.36000001430511, 0.37066650390625)
	flashalpha = 0.5
	tween.tween_method(nerfmaterialmodify,1.0,0.0,0.5)
	await tween.finished
	$hud/nerfs.visible = false
	buffsappear()
	

func buffsappear():
	$hud/buffmessage.visible = true
	var randombuff : int = randi_range(0,9)
	$hud/buffmessage/Label.text = str(round(100 - (nerfseverity * 100))) + "% " + buffs[randombuff]
	buff(randombuff)
	$hud/flash.color = Color(0.47000002861023, 1, 0.55833327770233)
	flashalpha = 0.5
	var tween = create_tween()
	tween.tween_method(buffmaterialmodify,0.0,1.0,0.5)
	tween.tween_method(buffmaterialmodify,1.0,0.0,0.5).set_delay(1)
	await tween.finished
	$hud/buffmessage.visible = false
	hp = maxhp
	nextboss()


func buffmaterialmodify(value):
	$hud/buffmessage.material.set_shader_parameter("percentage",value)

func nerfmaterialmodify(value):
	$hud/nerfs.material.set_shader_parameter("percentage",value)

func nextboss():
	bossesslain += 1
	hitless = true
	var b = preload("res://scenes/boss.tscn").instantiate()
	get_parent().add_child(b)
	b.position = Vector2(1152/2,648/2)
	b.hp = 1000 + bossesslain * 200
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(1152/2,600),0.5).set_trans(Tween.TRANS_CUBIC)
	
	
	

func _on_shotcooldown_timeout():
	canshoot = true


func _on_nerf_1_pressed():
	nerfseverity = $hud/nerfs/nerf1.nerfamount
	nerf($hud/nerfs/nerf1.nerftype, nerfseverity)


func _on_nerf_2_pressed():
	nerfseverity = $hud/nerfs/nerf2.nerfamount
	nerf($hud/nerfs/nerf2.nerftype, nerfseverity)


func _on_nerf_3_pressed():
	nerfseverity = $hud/nerfs/nerf3.nerfamount
	nerf($hud/nerfs/nerf3.nerftype, nerfseverity)
