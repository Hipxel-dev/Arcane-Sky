extends Area2D

var level_to_change 

func _on_level_change_trigger_body_entered(body: Node) -> void:
	if body.name == "player":
		get_tree().change_scene_to(level_to_change)
		level_to_change = null
		
