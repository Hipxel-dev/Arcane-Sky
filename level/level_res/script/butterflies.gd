extends AnimatedSprite

var slightly_change_target_interval = rand_range(0, 2)
var change_target_interval = rand_range(0, 6)

var starting_pos = Vector2.ZERO
var target = Vector2.ZERO
var movement = Vector2.ZERO

var sway_spd = rand_range(0.2, 0.4)
var sway_len = rand_range(5, 25)
var dist = 23200

#var colors = [Color.cyan, Color.yellow, Color.orange, Color.red, Color.green, Color.pink, Color.violet, Color.magenta]
var colors = [Color.cyan, Color.yellow]



func _ready() -> void:
	starting_pos = position
	offset = Vector2(rand_range(-14,14),rand_range(-14,14))
	starting_pos += Vector2(rand_range(-64,64),rand_range(-64,64))
	modulate = colors[floor(rand_range(0, colors.size()))]
	$Sprite.position = offset
	frame = floor(rand_range(0, 2.9))
	$sfx.volume_db = rand_range(-15, -5)
	$sfx.pitch_scale = rand_range(1, 3)
	
	if rand_range(0, 1) > 0.7:
		modulate = Color.yellow
	if rand_range(0, 1) > 0.9:
		modulate = Color.cyan
	
func _physics_process(delta: float) -> void:
	position += (movement / 2) * delta
	movement /= 1.02
	movement += (target - position) * 0.16
	
	slightly_change_target_interval -= delta
	change_target_interval -= delta

	movement += Vector2(rand_range(-14,14),rand_range(-14,14))
	rotation_degrees = movement.x / 10
	movement.y += (sin(OS.get_ticks_msec() * delta * sway_spd) * sway_len) 

	if slightly_change_target_interval < 0:
		movement += Vector2(rand_range(-64,64),rand_range(-64,64))
		slightly_change_target_interval = 0.5

	if change_target_interval < 0:
		movement += Vector2(rand_range(-164,164),rand_range(-164,164))
		change_target_interval = 2

	if starting_pos.distance_squared_to(global.player_pos) < dist:
		target = global.player_pos
	else:
		target = starting_pos
