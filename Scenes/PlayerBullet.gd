extends Area2D

var _speed = Global.bullet_speed_level[Global.levels[Global.player_level.bullet_speed]]

var _vel = Vector2()


func _ready():
	pass


func init(rot, pos):
	rotation = rot
	position = pos
	_vel = Vector2(_speed, 0).rotated(rot - PI / 2)


func _physics_process(delta):
	position += _vel * delta


func _on_Timer_timeout():
	queue_free()


func _on_PlayerBullet_body_entered(body : PhysicsBody2D):
	if body.get_groups().has("asteroids"):
		body.explode(_vel.normalized())
		queue_free()

func _on_PlayerBullet_area_entered(area):
	if area.get_groups().has("enemy"):
		area.take_damage(Global.player_damage)
		queue_free()
