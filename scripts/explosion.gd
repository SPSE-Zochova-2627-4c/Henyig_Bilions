extends Node3D
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
@onready var gpu_particles_3d_2: GPUParticles3D = $GPUParticles3D2

var time = 0
var start = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gpu_particles_3d_2.emitting = true
	

func _process(delta: float) -> void:
	time += delta
	if start == true and time > 0.02:
		gpu_particles_3d.emitting = true

func _on_gpu_particles_3d_finished() -> void:
	queue_free()


func _on_gpu_particles_3d_2_finished() -> void:
	pass
