extends Node2D

const enemies = [
	preload("res://enemy/enemies/enemy_membrane.tscn"),
	preload("res://enemy/enemies/enemy_eye_scepter.tscn"),
	preload("res://enemy/enemies/enemy_belch.tscn")
] 

var index = 0

var bullet = preload("res://player/projectile/scenes/bullet.tscn")
var fire_rate = 0.01
var shoot_sound = preload("res://sound/player/weapon_sfx/shotgun_shoot.wav")

var rot = 0

func _physics_process(delta: float) -> void:
	var inst = enemies[index].instance()
	$Label.text = inst.name
	$enemy_sprite_show.texture = inst.get_node("sprite").texture
	if Input.is_action_just_pressed("UP") and index < enemies.size() - 1:
		index += 1
	if Input.is_action_just_pressed("DOWN") and index > 0:
		index -= 1
	
	rot += 0.2
	global.player_pos = Vector2(480 / 2, 270 / 2) + Vector2(cos(rot), sin(rot)) * 100
	
	if Input.is_action_pressed("ALT_CLICK") and not Input.is_action_pressed("JUMP"):
		inst.position = get_local_mouse_position()
		inst.health = 99999999
		add_child(inst)
	elif Input.is_action_pressed("ALT_CLICK") and Input.is_action_pressed("JUMP"):
		var rand_inst = enemies[floor(rand_range(0, enemies.size() - 0.000001))].instance()
		rand_inst.position = get_local_mouse_position()
		add_child(rand_inst)
		
	fire_rate += delta
	if Input.is_action_pressed("CLICK") and fire_rate >= 0:
		fire_rate = -0.01
		
		for i in range(3):
			var bullet_inst = bullet.instance()
			bullet_inst.position = Vector2(480 / 2, 270 / 2)
			bullet_inst.damage = 50
#			bullet_inst.movement += (get_local_mouse_position() - bullet_inst.position).normalized() * 3000
			var angle_step = 2 * PI / 3
			var angle = i * angle_step + rot
			bullet_inst.movement += Vector2(cos(angle), sin(angle)) * 1000
			
			add_child(bullet_inst)
		
			fx.spwn_sound(shoot_sound, Vector2(480 / 2, 270), rand_range(-5, 0), rand_range(0.8, 1))
		
		
		
		
		
