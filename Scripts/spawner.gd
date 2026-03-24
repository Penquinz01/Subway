extends Node3D

@export var levelScene:PackedScene
@export var spawn_time:float
@onready var spawn_timer :=$"../SpawnTimer"

var current_level:Node
var prev_level:Node = null

func _ready() -> void:
	spawn_timer.wait_time = spawn_time
	spawnObject()


func spawnObject() -> void:
	if prev_level != null:
		prev_level.queue_free()
	prev_level = current_level
	current_level = levelScene.instantiate()
	add_child(current_level)
	print("Spawned")
	


func _on_spawn_timer_timeout() -> void:
	spawnObject()
	spawn_timer.start(spawn_time)
