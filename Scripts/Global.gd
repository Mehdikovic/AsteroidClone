extends Node

# game settings
var level_counter : int = 0
var game_over : bool = false
var score : int = 0
var paused : bool = false
var current_scene = null

# player settings
var shield_max_health : int = 100
var player_damage : int = 10

# level settings
enum player_level {
	thrust,
	rotation_speed,
	fire_rate,
	shield_regeneration_speed,
	shooting,
	bullet_speed,
	enemy_bullet_speed
}

var levels = {
	player_level.thrust : 4,
	player_level.rotation_speed : 4,
	player_level.fire_rate : 4,
	player_level.shield_regeneration_speed : 6,
	player_level.bullet_speed : 5,
	player_level.enemy_bullet_speed : 1,
	player_level.shooting : 3
}

var thrust_level = { 1: 200, 2: 300, 3: 400, 4: 600 }
var rotation_speed_level = { 1: 2.5, 2: 3, 3: 4, 4: 4.5 }
var fire_rate_level = { 1: 0.4, 2: 0.3, 3: 0.15, 4: 0.1 }
var shield_regeneration_speed_level = { 1: 1, 2: 2, 3: 4, 4: 6, 5: 8, 6: 10 }
var bullet_speed_level = { 1: 800, 2: 1000, 3: 1500, 4: 2000, 5: 4000 }
var enemy_bullet_speed_level = { 1: 300, 2: 450, 3: 600, 4: 800, 5: 1000 }
var shooting_level = { 1: [0], 2: [1, 2], 3: [0, 1, 2] }

# enemy settings
var enemy_damage : int = 20
var enemy_health : int = 30
var enemy_score : int = 100

# asteroid settings
var broken_pattern = {
	"lg" : "md",
	"md" : "sm",
	"sm" : "ti",
	"ti" : null
}

var asteroid_damage = {
	"lg" : 25,
	"md" : 15,
	"sm" : 10,
	"ti" : 5
}

var asteroid_point = {
	"lg" : 5,
	"md" : 15,
	"sm" : 25,
	"ti" : 30
}

var bullet_container : Node = null

func _ready():
	current_scene = get_tree().current_scene
	bullet_container = current_scene.find_node("Bullet")


func goto_scene(path: String):
	current_scene.queue_free()
	var res = ResourceLoader.load(path)
	var new_scene = res.instance()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	current_scene = new_scene
	bullet_container = current_scene.find_node("Bullet")


func new_game():
	game_over = false
	score = 0
	level_counter = 0
	call_deferred("goto_scene", "res://scenes/Main.tscn")



