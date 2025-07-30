extends GutTest

var player

# Executado antes de cada teste
func before_each():
	# Carrega a cena de teste do player
	var player_scene = load("res://Scenes/player_02.tscn")
	player = player_scene.instantiate()
	add_child(player)

func test_update_health_reduces_life():
	player.life.size.x = 52  # Define vida inicial
	player.update_health(10)  # Aplica dano
	assert_eq(player.life.size.x, 42, "A vida deveria ser reduzida para 75")
