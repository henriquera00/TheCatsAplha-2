extends CharacterBody2D

var state_machine
var in_attack: bool = false
var is_damage: bool = false
@export_category("Variables")
@export var speed: float = 80.0
@export var accel: float = 0.8
@export var brake: float = 0.4

@export_category("Objects")
@export var attack_timer: Timer = null
@export var animationtree: AnimationTree = null

func _ready() -> void:
	state_machine = animationtree["parameters/playback"]
	
	
func _physics_process(_delta: float)-> void:
	mover()
	attack()
	animated()
	move_and_slide()
	
func mover() -> void:
	var direction: Vector2 = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)
	
	if direction != Vector2.ZERO:
		animationtree["parameters/Idle/blend_position"] = direction
		animationtree["parameters/Attack/blend_position"] = direction
		animationtree["parameters/Run/blend_position"] = direction
		
		velocity.x = lerp(velocity.x, direction.normalized().x * speed, accel)
		velocity.y = lerp(velocity.y, direction.normalized().y * speed, accel)
		return
		
	velocity.x = lerp(velocity.x, direction.normalized().x * speed, brake)
	velocity.y = lerp(velocity.y, direction.normalized().y * speed, brake)
		
	velocity = direction.normalized() * speed
	
func attack() -> void:
	if Input.is_action_just_pressed("attack") and not in_attack:
		set_physics_process(false)
		attack_timer.start()
		in_attack = true

func animated() -> void:
	if is_damage:
		state_machine.travel("Damage")
		return
	
	if in_attack:
		state_machine.travel("Attack")
		return

	if velocity.length() > 5:
		state_machine.travel("Run")
		return
		
	state_machine.travel("Idle")
	pass



func _on_timer_timeout() -> void:
	set_physics_process(true)
	in_attack = false
