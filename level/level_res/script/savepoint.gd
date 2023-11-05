extends Node2D

var just_entered = false

func _draw() -> void:
	pass
#	for i in range(5):
#		draw_arc(Vector2.ZERO, 64 * (i * 1.1), -3.5, 3.5, 160, Color.cyan, 1.0)

func _physics_process(delta: float) -> void:
	update()
	if global_position.distance_squared_to(global.player_pos) < 2000:
		if just_entered == false:
			global.check_point_pos
			
			just_entered = true
	else:
		just_entered = false
