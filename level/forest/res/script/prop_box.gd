extends KinematicBody2D

var health = 1
var movement = Vector2.ZERO

var last_health = 1
var break_fx = preload("res://effects/misc_fx/box_break_fx.tscn")
var spr = [
	preload("res://art/level_art/box1.png"),
	preload("res://art/level_art/box2.png"),
	preload("res://art/level_art/box3.png")
]

func _ready() -> void:
	$sprite.texture = spr[floor(rand_range(0, spr.size() - 0.1))]
	
func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		movement.y += 8
	movement.x /= 1.1
	
	if health < 0:
#		fx.spwn_sound(preload("res://sound/action/woodbreak.wav"), position, 10, 0.4)
#		fx.spwn_sound(preload("res://sound/action/woodbreak.wav"), position, 20, 0.6)
		fx.spwn_sound(preload("res://sound/action/woodbreak.wav"), position, 10, 1)
		fx.spwn_sound(preload("res://sound/action/woodbreak.wav"), position, 15, 1.5)
		for i in rand_range(1, 5):
			game.spwn_gem(position)
			game.spwn_kalphite(position)
			fx.spwn_trail_phys(position, Color.chocolate)
			
		if rand_range(0, 1) > 0.5:
			game.spwn_bullet_ammo(position)
		if rand_range(0, 1) > 0.5:
			game.spwn_shell_ammo(position)
		for i in rand_range(2, 4):
			fx.spwn_gib($sprite.texture, position)

			
		var break_fx_inst = break_fx.instance()
		break_fx_inst.position = position
		get_parent().add_child(break_fx_inst)
			
		queue_free()
	
	if last_health != health:
#		fx.spwn_trail_phys(position, Color.chocolate)
#		fx.spwn_particle_trail(position)
#		fx.spwn_gib(position, $sprite.texture)
		fx.spwn_sound(preload("res://sound/action/woodbreak.wav"), position, 5, 1)
		last_health = health
		
#
	move_and_slide(movement, Vector2.UP)
