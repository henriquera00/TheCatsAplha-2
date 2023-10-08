extends CharacterBody2D

var state_machine
var in_attack: bool = false
@export_category("Variables")
@export var speed: float = 80.0
@export var accel: float = 0.8
@export var brake: float = 0.4

@export_category("Objects")
@export var attack_timer: Timer = null
@export var animationtree: AnimationTree = null

func _ready() -> void:
	animationtree.active = true
	state_machine = animationtree["parameters/playback"]
	
	
func _physics_process(_delta: float) -> void:
	mover()
	animated()
	attack()
	move_and_slide()
	
func mover() -> void:
	var direction: Vector2 = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)
	
	if direction != Vector2.ZERO:
		animationtree["parameters/Attack/blend_position"] = direction
		animationtree["parameters/Idle/blend_position"] = direction
		animationtree["parameters/Run/blend_position"] = direction
		
		velocity.x = lerp(velocity.x, direction.normalized().x * speed, accel)
		velocity.y = lerp(velocity.y, direction.normalized().y * speed, accel)
		return
		
	velocity.x = lerp(velocity.x, direction.normalized().x * speed, brake)
	velocity.y = lerp(velocity.y, direction.normalized().y * speed, brake)
		
	velocity = direction.normalized() * speed
	
func attack() -> void:
	if Input.is_action_just_pressed("attack") and not in_attack:
		attack_timer.start()
		in_attack = true

func animated() -> void:
	if in_attack:
		state_machine.travel("Attack")
		set_physics_process(false)		
		return

	if velocity.length() > 5:
		state_machine.travel("Run")
		return
		
	state_machine.travel("Idle")
	
	pass

func _on_attack_timer_timeout() -> void:
	set_physics_process(true)	
	in_attack = false	
	pass # Replace with function body.


func _on_attack_area_body_entered(body) -> void:
	if body.is_in_group("Enemy"):
		body.update_health(randi_range(1,5))
	pass # Replace with function body.
