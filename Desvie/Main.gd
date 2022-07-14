extends Node

export(PackedScene) var mob_scene
var score

func _ready():
	randomize()
	new_game()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Musica.stop()
	$SomDeMorte.play()

func new_game():
	score = 0
	$Jogador.start($StartPosition.position)
	$HUD.update_score(score)
	$StarTimer.start()
	$HUD.show_message("Prepare-se...")
	yield($StarTimer, "timeout")
	$ScoreTimer.start()
	$MobTimer.start()
	$Musica.play()
	
	get_tree().call_group("mobs", "queue_free")

func _on_StarTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_MobTimer_timeout():
	var mob = mob_scene.instance()
	
	var mob_spawn_location = get_node("CaminhoTurba/LocalGeracaoTurba")
	mob_spawn_location.offset = randi()
	
	var direction = mob_spawn_location.rotation + PI / 2
	
	mob.position = mob_spawn_location.position
	
	direction += rand_range(-PI / 4, PI /4)
	mob.rotation = direction
	
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
