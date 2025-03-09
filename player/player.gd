extends Area2D

signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

@onready var gun = get_node(^"Gun") as Gun

var rotation_velocity = 0
const rotation_velocity_cap = 6

#
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
#
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
#
func _process(delta):
	
	var velocity = Vector2.ZERO # The player's movement vector.
	var spinning = 0
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("spin_left"):
		spinning = -1
	if Input.is_action_pressed("spin_right"):
		spinning = 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if spinning == 0:
		rotation_velocity = rotation_velocity / 1.005
		if rotation_velocity < 0.005 and rotation_velocity > 0.005:
			rotation_velocity = 0
	else:
		rotation_velocity += 0.1 * spinning
			
	rotation_velocity = min(rotation_velocity, rotation_velocity_cap)
	set_rotation_degrees(get_rotation_degrees() + rotation_velocity)

	# now set the player's direction facing
	$AnimatedSprite2D.flip_v = false
	$AnimatedSprite2D.flip_h = rotation_velocity < 0
	
	if Input.is_action_just_pressed("shoot"):
		gun.shoot($AnimatedSprite2D.flip_h, rotation)

#
func _on_body_entered(body: Node2D):
	if body is Mob:
		hide() # Player disappears after being hit.
		hit.emit()

		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
