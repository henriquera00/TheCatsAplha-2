extends CharacterBody2D
class_name Slime

var state_machine
var player_ref = null
var is_dead: bool = false

@export_category("Objects")
@export var texture: Sprite2D = null
@export var animation: AnimationPlayer = null
@export var animationtree: AnimationTree = null

func _ready() -> void:
	animationtree.active = true
	state_machine = animationtree["parameters/playback"]

func _on_detection_body_entered(body) -> void:
	if body.is_in_group("Player"):
		player_ref = body
	pass # Replace with function body.


func _on_detection_body_exited(body):
	if body.is_in_group("Player"):
		player_ref = null

	pass # Replace with function body.
	
	
func _physics_process(delta: float)-> void:
	
	if is_dead:
		return
	
	
	
	
	animated()
	if player_ref != null:
		var direction : Vector2 = global_position.direction_to(player_ref.global_position) 
		var distance : float = global_position.distance_to(player_ref.global_position)
		
		if direction != Vector2.ZERO:
				animationtree["parameters/idle/blend_position"] = direction
				animationtree["parameters/Run/blend_position"] = direction
		
#		if distance < 15:
#			get_tree().reload_current_scene()
		
		velocity = direction.normalized() * 50
		
		move_and_slide()
		




func animated() -> void:
	if velocity.length() > 8:
		state_machine.travel("Run")
		return
	
	animationtree["parameters/idle/blend_position"] = Vector2.DOWN
	state_machine.travel("idle")
	pass
	
func update_health() -> void:
	is_dead = true
	queue_free()


func _on_damage_body_entered(body) -> void:
	if body.is_in_group("Player"):
		#body.update_health()
		print("ENTROU")
	pass # Replace with function body.
