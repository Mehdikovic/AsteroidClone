extends KinematicBody2D

signal on_exploded

var _size
var _velocity = Vector2.ZERO
var _rot_speed = 0
var _screen_size = Vector2.ZERO
var _extents = Vector2.ZERO
var _bounce = 1.01


var textures = {
	"lg" : ["res://Art/PNG/Meteors/meteorGrey_big1.png", "res://Art/PNG/Meteors/meteorGrey_big2.png", "res://Art/PNG/Meteors/meteorGrey_big3.png", "res://Art/PNG/Meteors/meteorGrey_big4.png"],
	"md" : ["res://Art/PNG/Meteors/meteorGrey_med1.png", "res://Art/PNG/Meteors/meteorGrey_med2.png"],
	"sm" : ["res://Art/PNG/Meteors/meteorGrey_small1.png", "res://Art/PNG/Meteors/meteorGrey_small2.png"],
	"ti" : ["res://Art/PNG/Meteors/meteorGrey_tiny1.png", "res://Art/PNG/Meteors/meteorGrey_tiny2.png"]
}

func _ready():
	randomize()
	_screen_size = get_viewport_rect().size

func init(init_size, init_pos, init_velocity = Vector2.ZERO):
	add_to_group("asteroids")

	_size = init_size

	global_position = init_pos

	if init_velocity == Vector2.ZERO:
		#set speed and direction
		_velocity = Vector2(rand_range(30, 100), 0).rotated(rand_range(0, 2 * PI))
	else:
		_velocity = init_velocity

	#set rotation speed in Radians
	_rot_speed = rand_range(-1.5, 1.5)

	var texture = textures[_size][randi() % textures[_size].size()]
	$Sprite.texture = load(texture)
	var new_shape = CircleShape2D.new()
	new_shape.radius = min($Sprite.texture.get_size().x / 2, $Sprite.texture.get_size().y /2)
	$CollisionShape2D.shape = new_shape
	_extents = $Sprite.texture.get_size() / 2


func _physics_process(delta):
	_velocity = _velocity.clamped(150)
	#handle off screen
	if position.x > _screen_size.x + _extents.x:
		position.x = -_extents.x
	if position.x < -_extents.x:
		position.x = _screen_size.x + _extents.x
	if position.y > _screen_size.y + _extents.y:
		position.y = -_extents.y
	if position.y < -_extents.y:
		position.y = _screen_size.y + _extents.y

	rotation += _rot_speed * delta
	var collided = move_and_collide(_velocity * delta)
	if collided:
		_velocity = collided.normal * collided.collider_velocity.length() * _bounce
		$Particle.global_position = collided.position
		$Particle.emitting = true


func explode(hit_direction : Vector2):
	emit_signal("on_exploded", _size, position, _velocity, hit_direction)
	Global.score += Global.asteroid_point[_size]
	queue_free()



