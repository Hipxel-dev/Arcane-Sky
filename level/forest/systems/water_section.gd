extends Node2D
class_name water

var water_segment = preload("res://effects/level_fx/water_segment.tscn")
var segment = []

#var movement_range = Vector2(0, 2)

# we need to give it an id so the other water sections on the map dont intersect.
var section_id = rand_range(-999999999999999999999999,9999999999999999999999)
var section_group_string = ""


var segpos_first_x = 0
var segpos_last_x = 0

var splash = preload("res://effects/level_fx/splash.tscn")

var separation = 1
var height = 20
var activated = true

var pos_for_near_player_detection = Vector2.ZERO
var near_player = false

var player_submerged = false
var player_inside_water = false
var player_touch_water = false
var needed_additional_y_pos_for_player_to_get_out = 18

var amplitude = 3 # def 2
var frequency = 6 # def 1

var last_player_pos = Vector2.ZERO
var pos = Vector2.ZERO

var surface_color = Color8(0, 150, 255, 255)
var water_color = Color8(0, 150, 200,55)

func _ready() -> void:
	randomize()
	
	for i in range($ColorRect.margin_right / separation):
		var water_segment_inst = water_segment.instance()
		water_segment_inst.position = Vector2(i * separation, 0)
		water_segment_inst.add_to_group(str("water", section_id))
		add_child(water_segment_inst)
		section_group_string = str("water", section_id)
		
		segment = get_tree().get_nodes_in_group(str(section_group_string))
		$ColorRect.queue_free()
		
		water_segment_inst.scale.y = height / 10
		
		pos_for_near_player_detection = global_position + Vector2( (i * separation) / 2, 0)
		
	$underwater_rect.rect_position.x = segment[0].position.x
	
	$surface_rect.position.y += 4
	$surface_rect.scale.x *= $ColorRect.margin_right / 2.8
	$surface_rect.position.x *= -$ColorRect.margin_right / 2.8
	
	segpos_first_x = segment[0].global_position.x
	segpos_last_x = segment[segment.size() - 1].global_position.x
	$underwater_rect.hide()
	
	
#	$underwater_rect.rect_position 
func _draw() -> void:
	$underwater_rect.color = water_color
	pos = global.player_pos - position
	for i in range(segment.size() - 1):
		
		var segpos = segment[i].position
		
		# draw a line from the segment to the next segment.
#		draw_line(segment[i].position, segment[i + 1].position, surface_color, 1)
		# draw a line downwards from the segment to create the underwater portion.
#		draw_line(segpos, Vector2(i * separation, height), water_color, separation)
		
		
		if near_player:
			
#			var y = amplitude * sin(i * frequency + OS.get_ticks_msec() * -0.01)
			
			
#			segment[1].position.y = 0
#			segment[segment.size() - 6].position.y = 0
			
			# make the segment magnetize to the neighbouring segments to create a wave and ripple effect
			segment[i].movement.y += (segment[i - 1].position.y - segment[i].position.y) * 58 
			segment[i - 2].movement.y += (segment[i - 1].position.y - segment[i - 2].position.y) * 58
				
			# spread them out on a horizontal line.
			segment[i].movement += (Vector2(i * separation, 0) - segment[i].position) 
			
			
			# make the player interact with water. using distance check and making the y vel move away from player
			# gives a cool surface tension effect.
			
#			var player_spd = abs(global.player_vel.y * 0.020) + abs(global.player_pos.x * 0.005)
			
			
			if activated:
				if pos.distance_squared_to(segment[i].position) < 200:
					if rand_range(0, 1) > 0.95:
						var splash_inst = splash.instance()
						splash_inst.position = segment[i].global_position 
						get_tree().get_root().add_child(splash_inst)
					segment[i].movement.y -= (pos.y - segment[i].position.y) * 5
#	#				segment[i].movement.y -= (pos.y - segment[i].position.y) * 5
			
func _physics_process(delta: float) -> void:
	$underwater_rect.margin_right = segment.size() * separation
	$underwater_rect.rect_position.y = height
	
	if near_player:
		update()
		var p = get_tree().get_nodes_in_group("p")
		if p[0].moving:
			activated = true
			last_player_pos = global.player_pos
		else:
			activated = false
			
		# we need the player pos again. this time make it slightly higher. forgot  what it does but it kinda makes the swimming better.
		var player_pos = global.player_pos + Vector2(0, -6)
		
#		segment[floor(rand_range(0, segment.size() - 1))].movement.y += rand_range(-50,50)
		
		# we need to make sure the player is inside the body of water.
		if player_pos.x > segment[0].global_position.x and player_pos.x < segment[segment.size() - 1].global_position.x and player_pos.y > (global_position.y + -16) and player_pos.y < global_position.y + height:
			player_touch_water = true
		else:
			player_touch_water = false
			
		if player_pos.x > segment[0].global_position.x and player_pos.x < segment[segment.size() - 1].global_position.x and player_pos.y > global_position.y and player_pos.y < global_position.y + (height + $underwater_rect.margin_bottom):
			global.water_pos = global_position
			player_inside_water = true
			
			if player_pos.y > global_position.y + 1:
				global.submerged = true
		
			
		# it makes getting out of the water felt smoother.
		if player_pos.y < global_position.y - needed_additional_y_pos_for_player_to_get_out:
			player_inside_water = false
	else:
		for i in segment:
			i.movement = Vector2.ZERO


func _on_surface_rect_area_entered(area):
	var hit_pos = (area.global_position + Vector2(0, -4)) - position
	for i in range(segment.size()):
		if hit_pos.distance_squared_to(segment[i].position) < 250:
			segment[i].movement.y += 150
			
			var splash_inst = splash.instance()
			splash_inst.position = segment[i].global_position 
			get_tree().get_root().add_child(splash_inst)
			
	


