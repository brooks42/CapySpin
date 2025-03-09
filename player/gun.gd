
class_name Gun extends Marker2D
## Represents a weapon that spawns and shoots bullets.
## The Cooldown timer controls the cooldown duration between shots.

const BULLET_VELOCITY = 850.0
const BULLET_SCENE = preload("res://player/apple.tscn")

@onready var sound_shoot := $AppleTossSound as AudioStreamPlayer

# This method is only called by Player.gd.
func shoot(flipshot: bool, direction: float):
	var bullet := BULLET_SCENE.instantiate() as Apple
	bullet.global_position = global_position
	
	if !flipshot:
		bullet.linear_velocity = Vector2.RIGHT.rotated(direction) * BULLET_VELOCITY
	else:
		bullet.linear_velocity = Vector2.LEFT.rotated(direction) * BULLET_VELOCITY
			
	bullet.set_as_top_level(true)
	add_child(bullet)
	sound_shoot.play()
