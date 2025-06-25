extends CharacterBody2D
class_name Slime

var state_machine
var player_ref = null
var is_dead: bool = false
var contact: bool = true

@export_category("Variables")
@export var speed: float = 15.0
@export var accel: float = 0.4
@export var brake: float = 0.2
@export var damage: float = 5.0

@export_category("Objects")
@export var texture: Sprite2D = null
@export var animation: AnimationPlayer = null
@export var animationtree: AnimationTree = null
@export var Timer_Damage: Timer = null
@export var life: ColorRect = null

func _ready() -> void:
	animationtree.active = true
	state_machine = animationtree["parameters/playback"]
	state_machine.travel("idle")
	

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
		
		velocity.x = lerp(velocity.x, direction.normalized().x * speed, accel)
		velocity.y = lerp(velocity.y, direction.normalized().y * speed, accel)
		
		move_and_slide()

func animated() -> void:
	if velocity.length() > 8:
		state_machine.travel("Run")
		return
	
	animationtree["parameters/idle/blend_position"] = Vector2.DOWN
	state_machine.travel("idle")
	pass

func update_health(damage: float) -> void:
	life.size.x -= damage
	
	if life.size.x <= 0: 
		is_dead = true
		queue_free()
	pass

func _on_damage_body_entered(body) -> void:
	#if body.is_in_group("Player"):
	#	body.update_health(damage)
	#	print("ENTROU")
	#	Timer_Damage.start()
	pass # Replace with function body.

func _on_body_damage_body_exited(body):
	Timer_Damage.stop()
	print("SAIU")
	pass # Replace with function body.

func _on_timer_damage_timeout(body):
	_on_damage_body_entered(body)
	pass # Replace with function body.
