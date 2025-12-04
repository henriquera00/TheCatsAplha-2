extends CanvasLayer
@onready var animator = $bg_dead_menu/Animator
func _ready() -> void:
	visible = false
	get_tree().paused = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			animator.play("pause_game")
			visible = false
			get_tree().paused = false
		else:
			visible = true
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
