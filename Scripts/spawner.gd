extends Node3D

@export var levelScene:PackedScene
@export var spawn_time:float
@onready var spawn_timer :=$"../SpawnTimer"

@export var vehicle_left:RigidBody3D
@export var vehicle_mid:RigidBody3D
@export var vehicle_right:RigidBody3D

var current_level:Node
var prev_level:Node = null

func _ready() -> void:
	spawn_timer.wait_time = spawn_time
	vehicle_left.hide()
	vehicle_mid.hide()
	vehicle_right.hide()
	spawnObject()


func spawnObject() -> void:
	if current_level != null:
		prev_level = current_level
		prev_level.queue_free()
	current_level = levelScene.instantiate()
	add_child(current_level)
	if prev_level == null:
		print("Deleted the last node")
	print("Spawned")
	


func _on_spawn_timer_timeout() -> void:
	spawnObject()
	spawn_timer.start(spawn_time)

func _on_vehicle_spawn(answer:bool) -> void:
	vehicle_mid.show()
	vehicle_mid.move()
	if answer:
		vehicle_right.show()
		vehicle_right.move()
	else:
		vehicle_left.show()
		vehicle_left.move()

	
	print("Spawining vehicle")

func _on_vehicle_stop():
	vehicle_left.stop()
	vehicle_mid.stop()
	vehicle_right.stop()
