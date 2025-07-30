extends GutTest

var player
var enemy

# Executado antes de cada teste
func before_each():
	# Carrega a cena de teste do player
	var player_scene = load("res://Scenes/player_02.tscn")
	player = player_scene.instantiate()
	add_child(player)
	player.in_attack = false
	player.attack_timer = Timer.new()
	add_child(player.attack_timer)
	
	# Corrige todos os nós exportados manualmente
	var fake_life = ColorRect.new()
	fake_life.size = Vector2(50, 5)
	player.life = fake_life

	var fake_timer = Timer.new()
	add_child(fake_timer)
	player.regen_timer = fake_timer

	# Certifica que o valor de regeneração está definido
	player.regen = 1.0
	
	var enemy_scene = load("res://Scenes/enemy_slime.tscn")
	enemy = enemy_scene.instantiate()
	add_child(enemy)

#Teste para saber se a Vida do Inimigo está sofrendo update de dano corretamente
func test_enemy_update_health_reduces_life():
	enemy.life.size.x = 38
	enemy.update_health(10)
	assert_eq(enemy.life.size.x, 28, "A vida deveria ser reduzida para 28")

#Teste para saber se a Vida do Player está sofrendo update de dano corretamente
func test_player_update_health_reduces_life():
	player.life.size.x = 52  # Define vida inicial
	player.update_health(10)  # Aplica dano
	assert_eq(player.life.size.x, 42, "A vida deveria ser reduzida para 42")

#Teste para saber se a variável booleana in_attack reseta sempre que o timer retorna
func test_attack_timer_timeout_resets_attack():
	player.in_attack = true
	player._on_attack_timer_timeout()
	assert_false(player.in_attack, "in_attack deveria ser false após timeout do ataque")

#Teste para saber se a regeneração está iniciando
func test_recovery_starts_regen_timer_if_life_low():
	player.life.size.x = 40
	player.recovery()
	assert_false(player.regen_timer.is_stopped(), "Timer de regeneração deveria ter iniciado")

#Teste para saber se caso o regen suba demais a vida, ela se ajuda ao limite máximo
func test_recovery_caps_life_to_52_if_above():
	player.life.size.x = 60
	player.recovery()
	assert_eq(player.life.size.x, 52, "Vida deve ser ajustada para 52")

#Teste para saber se a função recovery está funcionando corretamente
func test_regen_timeout_increases_life():
	player.life.size.x = 50
	player._on_regen_delay_timeout()
	assert_eq(player.life.size.x, 51, "Vida deveria ter aumentado em 1 ponto")
