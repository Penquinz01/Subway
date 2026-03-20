extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var leftPosition:Vector3
@export var midPosition:Vector3
@export var rightPosition:Vector3

var current_position:Vector3 = midPosition

func _ready() -> void:
	position = current_position


func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_axis("Left","Right");
	var dir:int;
	if(input_dir<0):
		dir = -1
	elif input_dir > 0:
		dir = 1
	else:
		dir = 0


func from_midPos(dir:int)->void:
	match dir:
		1:
			current_position = rightPosition
		-1:
			current_position = leftPosition
		0:
			current_position = midPosition
		_:
			print("Idk How that happened,Sorry")

func from_leftPos(dir:int)->void:
	match dir:
		1:
			current_position = midPosition
		-1:
			current_position = leftPosition
		0:
			current_position = leftPosition
		_:
			print("Idk How that happened,Sorry")

func from_rightPos(dir:int)->void:
	match dir:
		1:
			current_position = rightPosition
		-1:
			current_position = midPosition
		0:
			current_position = rightPosition
		_:
			print("Idk How that happened,Sorry")
	
