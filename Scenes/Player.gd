extends Area2D

signal on_dead

var _rotation_speed = Global.rotation_speed_level[Global.levels[Global.player_level.rotation_speed]]
var _thrust = Global.thrust_level[Global.levels[Global.player_level.thrust]]
export (PackedScene) var _bullet

var _screen_size = Vector2()
var _rotation = 0
var _position = Vector2()
var _velocity = Vector2()
var _acceleration = Vector2()
var _friction = 0.65

var shield_health = Global.shield_max_health
var shield_regeneration_speed = Global.shield_regeneration_speed_level[Global.levels[Global.player_level.shield_regeneration_speed]]
var shield_active = true


func _ready():
	add_to_group("player")
	print(shield_regeneration_speed)
	_screen_size = get_viewport_rect().size
	_position = _screen_size / 2
	position = _position
	$FireRateTimer.wait_time = Global.fire_rate_level[Global.levels[Global.player_level.fire_rate]]

func _process(delta):
	#regenerating shield health
	regenerate_shield_health(delta)
	activate_shield()
	#handle shooting
	if Input.is_action_pressed("ui_select"):
			_shooting()

	#handle movement and inputs here
	_movement(delta)

	position = _position
	rotation = _rotation + PI / 2


func _movement(delta):
	var stop_scaler = 1
	if Input.is_action_pressed("ui_right"):
		_rotation += _rotation_speed * delta
	if Input.is_action_pressed("ui_left"):
		_rotation -= _rotation_speed * delta
	if Input.is_action_pressed("ui_down"):
		stop_scaler = 3
	if Input.is_action_pressed("ui_up"):
		_acceleration = Vector2(_thrust, 0).rotated(_rotation)
		$Exhaust.show()
	else:
		_acceleration = Vector2()
		$Exhaust.hide()

	_acceleration += _velocity * -_friction * stop_scaler
	_velocity += _acceleration * delta
	_position += _velocity * delta

	#Begin screen wrapping
	if _position.x > _screen_size.x:
		_position.x = 0
	elif _position.x < 0:
		_position.x = _screen_size.x
	if _position.y > _screen_size.y:
		_position.y = 0
	elif _position.y < 0:
		_position.y = _screen_size.y
	#End of screen wrapping


func _shooting():
	if $FireRateTimer.time_left != 0:
		return
	for i in Global.shooting_level[Global.levels[Global.player_level.shooting]]:
		$FireRateTimer.start()
		var bullet = _bullet.instance()
		Global.bullet_container.add_child(bullet)
		var offset = 0
		if i == 1: offset = -0.1
		if i == 2: offset = 0.1
		bullet.init(rotation + offset, $Muzzle.get_child(i).global_position)
		$Shooting.play()


func _on_Player_body_entered(body: PhysicsBody2D):
	if not visible:
		return

	if body.get_groups().has("asteroids"):
		body.explode(_velocity.normalized())
		shield_take_damage(Global.asteroid_damage[body._size])


func shield_take_damage(damage):
	if shield_active:
		shield_health -= damage
		if shield_health <= 0:
			shield_active = false
			shield_health = 0
			$Shield.hide()
	else:
		emit_signal("on_dead")

func regenerate_shield_health(delta):
	if not shield_active:
		return
	shield_health = min(100, shield_health + shield_regeneration_speed * delta)

func activate_shield():
	if shield_active:
		return
	if Input.is_action_just_pressed("ui_end"):
		shield_active = true
		shield_health = Global.shield_max_health
		$Shield.show()


func disabled():
	hide()
	set_process(false)

func take_damage(damage : int):
	shield_take_damage(damage)





