extends Area2D

var speed : float = Global.enemy_bullet_speed_level[Global.levels[Global.player_level.enemy_bullet_speed]]
var _vel : Vector2 = Vector2.ZERO

func _ready():
	pass

func init(pos, rot):
	position = pos
	rotation = rot + PI / 2
	_vel = Vector2(speed, 0).rotated(rot)


func _physics_process(delta):
	position += _vel * delta


func _on_Timer_timeout():
	queue_free()


func _on_EnemyBullet_area_entered(area : Area2D):
	if area.get_groups().has("player"):
		area.take_damage(Global.enemy_damage)
		queue_free()
