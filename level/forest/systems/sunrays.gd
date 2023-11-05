extends Node2D

var sunray = []
var blink_speed = []
var sway_strength = []
var sway_speed = []


func _ready() -> void:
	sunray = get_tree().get_nodes_in_group("ray")
	for i in range(sunray.size()):
		blink_speed.append(rand_range(-0.03, 0.08))
		sway_strength.append(rand_range(-0.5,0.5))
		sway_speed.append(rand_range(0.05, 0.2))
	
func _physics_process(delta: float) -> void:
	for i in range(sunray.size()):
		if sunray[i].position.x > global.camera_pos.x - 160 and sunray[i].position.x < global.camera_pos.x + 260:
			sunray[i].modulate = Color8(255,255,255, abs(sin(OS.get_ticks_msec() * delta * blink_speed[i]) * 255))
			sunray[i].position.x += sin(OS.get_ticks_msec() * delta * sway_speed[i]) * sway_strength[i]

