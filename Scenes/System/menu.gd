extends Control


func _on_jogar_pressed():
	get_tree().change_scene_to_file("res://Scenes/world_01.tscn")
	pass # Replace with function body.


func _on_créditos_pressed():
	get_tree().change_scene_to_file("res://Scenes/System/créditos.tscn")
	pass # Replace with function body.
