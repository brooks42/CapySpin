class_name Apple extends RigidBody2D

#
func destroy():
	self.queue_free()

#	
func _on_body_entered(body: Node):
	if body is Mob:
		print("got im")
		destroy()
		(body as Mob).on_shot()

#
func _on_timer_timeout():
	destroy()
