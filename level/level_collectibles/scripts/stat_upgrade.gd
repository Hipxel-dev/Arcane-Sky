extends Sprite

var t = 0

func _draw() -> void:
	for i in range(55):
		var scaler = 0
		scaler = 64
		var cosvec = Vector2(cos(i), sin(i))
		
#		draw_line(cosvec * (scaler + i), Vector2(cos(i + 1), sin(i + 1)) * (scaler + i), Color.white, 1)
		
		draw_circle(cosvec * (scaler), 5, Color.white)

func _physics_process(delta: float) -> void:
	t = delta
	update()
	if position.distance_squared_to(global.player_pos) < 500:
		init_ui()
		
func init_ui():
	pass
