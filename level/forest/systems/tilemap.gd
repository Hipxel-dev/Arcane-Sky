extends TileMap

onready var tilemap = null

var blue_flower = preload("res://effects/level_fx/blue_flower.tscn")
var yellow_flower = preload("res://effects/level_fx/yellow_flower.tscn")

func _ready() -> void:


	if $setdressing:
		tilemap = $setdressing
		for cellpos in tilemap.get_used_cells():
			var cell = tilemap.get_cellv(cellpos)

			if cell == 19:
				for i in rand_range(1, 1):
					var blue_flower_inst = blue_flower.instance()
					blue_flower_inst.position = tilemap.map_to_world(cellpos) * tilemap.scale

					blue_flower_inst.get_node("sfx").volume_db = rand_range(-0, 10)
					blue_flower_inst.get_node("sfx").pitch_scale = 2.7
					blue_flower_inst.rotation_degrees = 90

					blue_flower_inst.show_behind_parent = true

	#				blue_flower_inst.position.x += rand_range(-10,10)
	#				blue_flower_inst.position += Vector2(rand_range(-5, 5), rand_range(-1, 5))
					blue_flower_inst.position.y += 32

					add_child(blue_flower_inst)
					tilemap.set_cellv(cellpos, -1)


			if cell == 20:
				for i in rand_range(1, 1):
					var yellow_flower_inst = yellow_flower.instance()
					yellow_flower_inst.position = tilemap.map_to_world(cellpos) * tilemap.scale

					yellow_flower_inst.get_node("sfx").volume_db = rand_range(-0, 10)
					yellow_flower_inst.get_node("sfx").pitch_scale = 1.7
					yellow_flower_inst.rotation_degrees = 90

					yellow_flower_inst.show_behind_parent = true

	#				yellow_flower_inst.position.x += rand_range(-10,10)
	#				yellow_flower_inst.position += Vector2(rand_range(-5, 5), rand_range(-1, 5))
					yellow_flower_inst.position.y += 32

					add_child(yellow_flower_inst)
					tilemap.set_cellv(cellpos, -1)
			
			
			
