extends CharacterBody2D
class_name Slime

var player_ref = null

@export_category("Objects")
@export var texture: Sprite2D = null
@export var animation: AnimationPlayer = null


func _on_detection_body_entered(body) -> void:
	if body.is_in_group("Player"):
		player_ref = body
	pass # Replace with function body.


func _on_detection_body_exited(body):
	if body.is_in_group("Player"):
		player_ref = null
	pass # Replace with function body.
	
	
func _physics_process(delta: float)-> void:
	animated()
	if player_ref != null:
		var direction : Vector2 = global_position.direction_to(player_ref.global_position) 
		var distance : float = global_position.distance_to(player_ref.global_position)
		
		if distance < 2:
			player_ref.is_dead = true
		
		velocity = direction * 60
		
		move_and_slide()
		

func animated() -> void:
	if velocity.x > 0:
		animation.play("idle_left")
	
	if velocity.x < 0:
		animation.play("idle_right")
	
	if velocity != Vector2.ZERO:
		animation.play("idle_down")
		return
		
	animation.play("idle_down")
