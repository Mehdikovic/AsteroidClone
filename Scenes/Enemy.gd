extends Area2D

signal on_explode
signal on_shooting

var textures = {
	0 : "res://Art/PNG/ufoBlue.png",
	1 : "res://Art/PNG/ufoGreen.png",
	2 : "res://Art/PNG/ufoRed.png",
	3 : "res://Art/PNG/ufoYellow.png"
}

var enemy_bullet = preload("res://Scenes/EnemyBullet.tscn")

var path : Path2D
var follow : PathFollow2D
var agent : Node2D
var target = null
export var speed : float = 100
var is_dead : bool = false

var health = Global.enemy_health

func _ready():
	add_to_group("enemy")
	randomize()
	$Sprite.texture = load(textures[randi() % textures.size()])
	$FireRateTimer.wait_time = rand_range(1.5, 3)
	$FireRateTimer.start()
	path = $PathCollection.get_child(randi() % $PathCollection.get_child_count())
	follow = PathFollow2D.new()
	follow.loop = false
	path.add_child(follow)
	agent = Node2D.new()
	follow.add_child(agent)

func _process(delta):
	follow.offset += speed * delta
	position = agent.global_position
	if follow.unit_offset >= 1.0:
		$FireRateTimer.stop()
		if $BulletContainer.get_child_count() > 0:
			return
		queue_free()


func set_target(new_target):
	target = new_target


func _on_FireRateTimer_timeout():
	if not target.is_visible():
		return
	var rand = randi() % 3
	match rand:
		0:
			for i in range(3):
				shoot1()
				yield(get_tree().create_timer(0.1), "timeout")
		1:
			shoot1()
		2:
			shoot3()


func shoot1():
	var dir = target.global_position - global_position
	var bullet_instance = enemy_bullet.instance()
	Global.bullet_container.add_child(bullet_instance)
	bullet_instance.init(global_position, dir.angle())
	$Shoot.play()


func shoot3():
	var dir = target.global_position - global_position
	for angle_offset in [-0.1, 0, 0.1]:
		var bullet_instance = enemy_bullet.instance()
		Global.bullet_container.add_child(bullet_instance)
		bullet_instance.init(global_position, dir.angle() + angle_offset)
	$Shoot.play()


func take_damage(damage):
	health -= damage
	$Anim.play("hit")
	if health <= 0:
		Global.score += Global.enemy_score
		emit_signal("on_explode", global_position)
		queue_free()

