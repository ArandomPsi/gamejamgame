extends Node2D

var hp : int = 1000
var defaultcooldownmult : int = 1

var velocity : Vector2

var attackcooldown : int = 400

var attacks : Array = []
var everyattack : Array = ["move", "teleport","sweatyhell" ,"bigboulet", "wavybullets", "bullethell", "delayedbullets", "bouncybullets", "boomerangbullets", "boomboom"]

var flashalpha : float = 1

var time : float = 0
var movedir : Vector2
var moveframes : int = 0

func _ready():
	attacks.insert(0,everyattack.pick_random())
	attacks.insert(1,everyattack.pick_random())
	attacks.insert(2,everyattack.pick_random())
	attacks.insert(3,everyattack.pick_random())
	$formingup.emitting = true
	$Sprite2D.play(str(randi_range(0,6)))
	var tween = create_tween()
	tween.tween_property($Sprite2D,"scale",Vector2(2,2),0.8).set_trans(Tween.TRANS_CUBIC).set_delay(2)
	await tween.finished
	$formingup.emitting = false
	$aura.visible = true
	$aura.play(str(randi_range(0,6)))

func _process(delta):
	moveframes -= 1
	$Sprite2D.rotation_degrees -= 2
	$aura.rotation_degrees += 1
	time += delta
	$aura.scale = Vector2(1,1) * (sin(time * 2)/5 + 1.2)
	if hp < 1:
		die()
	if not $attackplayer.is_playing():
		attackcooldown -= 1
	if attackcooldown < 1:
		ai()
	updatepos(delta)
	
	if moveframes > 1:
		velocity += movedir * 10
	else:
		movedir = Vector2.ZERO
	
	#attackflash
	modulate = Color(1 + flashalpha,1 + flashalpha,1 + flashalpha,1)
	flashalpha *= 0.9
	

func ai():
	var attack = randi_range(0,2)
	match attacks[attack]:
		"move":
			move()
		"teleport":
			teleport()
			$aim.look_at(Vector2(1152/2,648/2))
			movedir = $aim.transform.x
			moveframes = randi_range(120,360)
		"bigboulet":
			$attackplayer.play("bigboulet")
			$aim.look_at(Vector2(1152/2,648/2))
			movedir = $aim.transform.x
			moveframes = randi_range(120,360)
		"delayedbullets":
			$attackplayer.play("delayedbullets")
		"bullethell":
			$attackplayer.play("bullethell")
			$aim.look_at(Vector2(1152/2,648/2))
			movedir = $aim.transform.x
			moveframes = randi_range(120,360)
		"wavybullets":
			$attackplayer.play("wavybullets")
		"bouncybullets":
			$attackplayer.play("bouncypew")
		"sweatyhell":
			$attackplayer.play("sweatyhell")
			$aim.look_at(Vector2(1152/2,648/2))
			movedir = $aim.transform.x
			moveframes = randi_range(120,360)
		"boomerangbullets":
			$attackplayer.play("boomeranghell")
		"boomboom":
			$attackplayer.play("boomboom")
			$aim.look_at(Vector2(1152/2,648/2))
			movedir = $aim.transform.x
			moveframes = randi_range(120,360)
		_:
			$attackplayer.play("bouncypew")
	attackcooldown = 120 * defaultcooldownmult

func updatepos(delta):
	
	#the vel stuff to replace move and slide
	velocity *= 0.95
	position += velocity * delta
	#keep from running away
	position.x = clamp(position.x,0 + 100, 1152 - 100)
	position.y = clamp(position.y,0 + 100,648 - 100)

func move():
	$aim.rotation_degrees = randi_range(0,360)
	velocity += $aim.transform.x * 1200

func teleport():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0),0.3)
	await tween.finished
	position = Vector2(randi_range(100,1000), randi_range(100,500))
	var tween2 = create_tween()
	tween2.tween_property(self, "modulate", Color(1,1,1,1),0.3)
	

func die():
	var b = preload("res://scenes/shards.tscn").instantiate()
	get_parent().add_child(b)
	b.position = position
	
	get_parent().get_child(2).nerfsappear()
	
	queue_free()
	

func spawndelayedbullets():
	for i in range(30):
		$aim.look_at(global.playerpos)
		var b = preload("res://scenes/delayedbullet.tscn").instantiate()
		get_parent().add_child(b)
		b.position = position
		b.rotation = $aim.rotation
		b.rotation_degrees += randf_range(-30,30)
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame

func bullethell():
	for i in range(40):
		$aim.look_at(global.playerpos)
		var b = preload("res://scenes/ordinarybullet.tscn").instantiate()
		get_parent().add_child(b)
		b.position = position
		b.rotation = $aim.rotation
		b.rotation_degrees += randf_range(-90,90)
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame

func boomboom():
	for i in range(30):
		var b = preload("res://scenes/boomboom.tscn").instantiate()
		get_parent().add_child(b)
		b.position = global.playerpos
		b.position += Vector2(randi_range(-50,50),randi_range(-50,50))
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		

func boomeranghell():
	$aim.look_at(global.playerpos)
	for i in range(30):
		var b = preload("res://scenes/boomerangbullet.tscn").instantiate()
		get_parent().add_child(b)
		b.position = position
		b.rotation = $aim.rotation
		$aim.rotation_degrees += randi_range(0,360)
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame

func sweatyhell():
	for i in range(40):
		$aim.look_at(global.playerpos)
		var b = preload("res://scenes/delayedbullet.tscn").instantiate()
		get_parent().add_child(b)
		b.position = position
		b.rotation = $aim.rotation
		b.rotation_degrees += randf_range(-180,180)
		b.targetagain = false
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame

func take_damage(damage):
	hp -= damage
	flashalpha = 1
	print(str(hp))
	

func wavypew():
	$aim.look_at(global.playerpos)
	for i in range(5):
		for v in range(5):
			var b = preload("res://scenes/wavybullet.tscn").instantiate()
			get_parent().add_child(b)
			b.position = position
			b.rotation = $aim.rotation
			$aim.rotation_degrees += randi_range(0,360)
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame

func bouncypew():
	$aim.look_at(global.playerpos)
	for i in range(3):
		var grota = randi_range(-90,90)
		for v in range(8):
			var b = preload("res://scenes/bouncybullet.tscn").instantiate()
			get_parent().add_child(b)
			b.position = position
			b.rotation = $aim.rotation
			b.grouprotation = grota
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			
		$aim.rotation_degrees += randi_range(10,20)
		

func ultimatewavypew():
	$aim.look_at(global.playerpos)
	for i in range(20):
		for v in range(20):
			var b = preload("res://scenes/wavybullet.tscn").instantiate()
			get_parent().add_child(b)
			b.position = position
			b.rotation = $aim.rotation
			$aim.rotation_degrees += 18
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame

func bigbouletpew():
	$aim.look_at(global.playerpos)
	var b = preload("res://scenes/bigboulet.tscn").instantiate()
	get_parent().add_child(b)
	b.position = position
	b.rotation = $aim.rotation
	
