extends Node2D



var modulates = [
	Color.cyan,
	Color.yellow,
	Color.green,
	Color.orange,
	Color.orangered,
	Color.purple,
	Color.magenta
]


func _physics_process(delta):
	if Input.is_action_just_pressed("ALT_CLICK"):
		OS.window_fullscreen = !OS.window_fullscreen
		
	if Input.is_action_just_pressed("CLICK"):
		fx.spwn_explosion_pack_sml(get_global_mouse_position())
		fx.spwn_big_explosion(get_global_mouse_position())
		fx.spwn_upward_explosion(get_global_mouse_position())
		
		for i in range(6):
			fx.spwn_impact(get_global_mouse_position())
		for i in range(3):
			fx.spwn_trail_phys(get_global_mouse_position(), Color.yellow)
			fx.spwn_trail_phys(get_global_mouse_position(), Color.orangered)
			fx.spwn_trail_phys(get_global_mouse_position(), Color.orange)
	
#	if Input.is_action_pressed("CLICK"):
#		for i in range(6):
#			fx.spwn_trail_phys(get_global_mouse_position(), modulates[floor(rand_range(0, modulates.size()))])











































#extends Node2D
#
#var tex = preload("res://art/player_art/ui_art/general_ui_art/pixel.png")
#var fire_rate = 0.07
#
#var particles = []
#
#var p = {
#	"pos": Vector2(160, 90),
#	"vel": Vector2.ZERO,
#	"hp": 5
#}
#
#var bullets = []
#var blt = []
#
#var enemy_spwn_rate = 0
#var enemy = []
#
#func _draw() -> void:
#	# draw_bullet
#	for bullet in blt:
#		draw_circle(bullet["pos"], 4, Color.yellow)
#
#	# draw enemies
#	for enm in enemy:
#		draw_circle(enm["pos"], 6, Color.orangered)
#
#	# draw_player
#	draw_circle(p["pos"], 8, Color.cyan)
#
#	for prtcl in particles:
#		draw_circle(prtcl["pos"], prtcl["time"] * 2, Color.cyan)
##		draw_line(prtcl["pos"], -(prtcl["vel"] * 0.1667)+ prtcl["pos"], Color.white, 1.0)
#
#func _physics_process(delta: float) -> void:
#	update()
#	bullet(delta)
#	enemy(delta)
#	controls(delta)
#
#func enemy(delta):
#	enemy_spwn_rate -= delta
#	if enemy_spwn_rate < 0:
#		var enm_data = {
#			"pos": Vector2(rand_range(-0, 320), rand_range(-0,180)),
#			"vel": Vector2.ZERO,
#			"health": 1,
#			"lifetime": 3
#		}
#		enemy.append(enm_data)
#		enemy_spwn_rate = 0.5
#
#	for enm in enemy:
#		enm["pos"] += enm["vel"]
#		enm["lifetime"] -= delta
#		if enm["lifetime"] < 0:
#			enemy.pop_front()
#
#func bullet(delta):
#	for b in blt:
#		b["time"] -= delta
#		b["pos"] += b["vel"] * delta
#		b["vel"] /= 1.04
#
#		if b["time"] < 0:
#			blt.pop_front()
#
#		bullets = b
#
#func controls(delta):
#	p["pos"] += p["vel"] * delta
#	p["vel"].x += (Input.get_action_strength("RIGHT") * 200 - Input.get_action_strength("LEFT") * 200 - p["vel"].x) * 0.16
#	p["vel"].y += (Input.get_action_strength("DOWN") * 200 - Input.get_action_strength("UP") * 200 - p["vel"].y) * 0.16
#
#	if p["vel"].length() > 200:
#		p["vel"] = p["vel"].normalized() * 200
#
#	fire_rate += delta
#	if Input.is_action_pressed("CLICK") and fire_rate >= 0:
#		fire_rate = -0.07
#		var blt_data = {
#			"pos": p["pos"],
#			"vel": (get_local_mouse_position() - p["pos"]).normalized() * 600,
#			"time": 1
#		}
#		blt.append(blt_data)
#
#	if particles.size() < 50:
#		var p = {
#			"pos": get_local_mouse_position(),
#			"vel": Vector2(rand_range(-100,100), rand_range(-100,100)),
#			"time": rand_range(1, 3)
#		}
#		particles.append(p)
#	for prtcl in particles:
#		prtcl["pos"] += prtcl["vel"] * delta
#		prtcl["time"] -= delta
#		prtcl["vel"] /= 1.03
#		if prtcl["time"] < 0:
#			prtcl["pos"] = p["pos"]
#			prtcl["vel"] = Vector2(rand_range(-100,100), rand_range(-100,100))
#			prtcl["time"] = rand_range(1, 3)
#	update()









