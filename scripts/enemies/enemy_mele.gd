extends Area3D
@onready var timer: Timer = $Timer
@onready var player = get_tree().get_root().get_node("World").get_node("Player")
@onready var cooldown = false



func _process(_delta: float) -> void:
	if player in self.get_overlapping_bodies() and not cooldown:
		player.damage(5,0,self.global_position,false)
		cooldown = true
		timer.start()


func _on_timer_timeout() -> void:
	cooldown = false
