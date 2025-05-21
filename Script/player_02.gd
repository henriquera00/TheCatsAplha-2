extends CharacterBody2D

var state_machine
var in_attack: bool = false
var is_damage:bool = false
var is_dead: bool = false
@export_category("Variables")
@export var speed: float = 100.0
@export var accel: float = 0.8
@export var brake: float = 0.4
@export var regen: float = 1.0
@export var damage: float = 10.0

@export_category("Objects")
@export var attack_timer: Timer = null
@export var regen_timer: Timer = null
@export var animationtree: AnimationTree = null
@export var life: ColorRect = null

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
	
		
	velocity.x = lerp(velocity.x, 0.0, brake)
	velocity.y = lerp(velocity.y, 0.0, brake)
		
	#velocity = direction.normalized() * speed
	
func attack() -> void:
	if Input.is_action_just_pressed("attack") and not in_attack:
		attack_timer.start()
		in_attack = true

func animated() -> void:
	
	if is_damage:
		state_machine.travel("Dead")
		
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


#Função para dar Dano ao inimigo, ao entrar na área de contato
func _on_attack_area_body_entered(body) -> void:
	if body.is_in_group("Enemy"):
		body.update_health(damage)
	pass # Replace with function body.

func update_health(damage) -> void:
	life.size.x -= damage
	print("DANO")
	pass
	
func recovery():
	if life.size.x <= 52:
		regen_timer.start()
	else:
		life.size.x = 52
		print("Regeneração completa")
	pass
func _on_spawn_timer_timeout():
	pass # Replace with function body.

#função que faz receber dano após inimigo entrar na área de dano
func _on_damage_area_body_entered(body) -> void:
	if body.is_in_group("Enemy"):
		update_health(body.damage)
		if life.size.x > 0:
			recovery()
			print("Tomou dano! Trouxa!")
		else:
			is_dead = true
			regen_timer.stop()
			get_tree().reload_current_scene()
			print("VOCÊ MORREU PATRÃO")
	pass # Replace with function body.


func _on_regen_delay_timeout():
	life.size.x += regen
	print("regenerou ", regen)
	recovery()
	pass # Replace with function body.
