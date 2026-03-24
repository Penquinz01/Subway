extends Node3D

@export var speed:float


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector3.BACK*speed*delta
