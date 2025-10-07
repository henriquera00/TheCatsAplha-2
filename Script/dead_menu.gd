extends CanvasLayer
@onready var animator = $bg_dead_menu/Animator

func _ready() -> void:
	visible = false
	get_tree().paused = false

func animated() -> void:
	visible = true
	animator.play("pause_game")
	get_tree().paused = true

func _on_return_pressed():
	visible = false
	get_tree().paused = false
	pass # Replace with function body.

func _on_restart_pressed():
	get_tree().reload_current_scene()
	pass # Replace with function body.

func _on_exit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/System/menu.tscn")
	pass # Replace with function body.
