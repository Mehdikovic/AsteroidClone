extends Node

var asteroid_scene = preload("res://Scenes/Asteroid.tscn")
var explosion_scene = preload("res://Scenes/Explosion.tscn")
var enemy_scene = preload("res://Scenes/Enemy.tscn")
var enemy_bullet = preload("res://Scenes/EnemyBullet.tscn")


func _ready():
	$Player.connect("on_dead", self, "on_player_dead")
	randomize()


func _process(delta):
	$HUD.update($Player)
	if $AsteroidContainer.get_child_count() == 0:
		next_level()


func next_level():
	Global.level_counter = Global.level_counter + 1
	$HUD.show_message("Wave %s" % Global.level_counter)
	for i in range(Global.level_counter):
		spawn_asteroid("lg", $AsteroidLocationSpwan.get_child(randi() % $AsteroidLocationSpwan.get_child_count()).global_position, Vector2.ZERO)
	spawn_enemy()


func spawn_asteroid(size: String, pos: Vector2, vel: Vector2) -> void:
	var asteroid = asteroid_scene.instance()
	$AsteroidContainer.add_child(asteroid)
	asteroid.init(size, pos, vel)
	asteroid.connect("on_exploded", self, "on_asteroid_exploded")


func spawn_enemy():
	if $EnemyContainer.get_child_count() >= 3:
		return
	yield(get_tree().create_timer(rand_range(10, 20)), "timeout")
	$EnemySpawnTimer.stop()
	$EnemySpawnTimer.wait_time = rand_range(10, 20)
	var enemy = enemy_scene.instance()
	enemy.connect("on_explode", self, "on_enemy_dead")
	$EnemyContainer.add_child(enemy)
	enemy.set_target($Player)
	$EnemySpawnTimer.start()


func on_asteroid_exploded(size: String, pos: Vector2, vel: Vector2, hit_direction: Vector2) -> void:
	var new_size = Global.broken_pattern[size]
	if new_size:
		for offset in [-1, 1]:
			var new_pos = pos + (hit_direction.tangent() * offset)
			var new_vel = vel + (hit_direction.tangent() * offset)
			call_deferred("spawn_asteroid", new_size, new_pos, new_vel)
	var explosion = explosion_scene.instance()
	add_child(explosion)
	explosion.position = pos
	explosion.play("normal")
	($ExplosionSounds.get_child(randi() % $ExplosionSounds.get_child_count())).play()


func on_player_dead():
	$Player.disabled()
	$HUD.show_message("GAME OVER!")
	var explosion = explosion_scene.instance()
	add_child(explosion)
	explosion.scale = Vector2(1.5, 1.5)
	explosion.position = $Player.position
	explosion.play("sonic")
	($ExplosionSounds.get_child(randi() % $ExplosionSounds.get_child_count())).play()
	yield(get_tree().create_timer(3), "timeout")
	Global.new_game()


func _on_EnemySpawnTimer_timeout():
	call_deferred("spawn_enemy")


func on_enemy_dead(pos):
	var explosion = explosion_scene.instance()
	add_child(explosion)
	explosion.scale = Vector2(1.1, 1.1)
	explosion.position = pos
	explosion.play("sonic")
	($ExplosionSounds.get_child(randi() % $ExplosionSounds.get_child_count())).play()

