extends RigidBody3D

@export var hp: int = 200
@export var explosion_dramaticism: float = 2


func _process(_delta):
	if hp <= 0:
		queue_free()
	
	
func damage(dmg):
	hp -= dmg

func get_explode(dmg,from_pos):
	hp -= dmg

	var direction = self.global_position.direction_to(from_pos)
	var speed = explosion_dramaticism * dmg
	direction *= -speed
	
	self.apply_central_impulse(direction)
