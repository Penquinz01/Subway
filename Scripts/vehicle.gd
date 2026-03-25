extends RigidBody3D

@export var vehicle_force:float

# Called when the node enters the scene tree for the first time.

func move() -> void:
	print("Called The Function")
	position = Vector3.ZERO
	apply_impulse(transform.basis.z* vehicle_force)

func stop()-> void:
	linear_velocity = Vector3.ZERO
	position = Vector3.ZERO
	hide()

