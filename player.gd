extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var leftPosition:Node3D
@export var midPosition:Node3D
@export var rightPosition:Node3D
@export var offset:float

var current_position:Vector3

func _ready() -> void:
	current_position = midPosition.position
	position = current_position


func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir_left := Input.is_action_just_pressed("Left");
	var input_dir_right := Input.is_action_just_pressed("Right");
	
	var left:int=1 if input_dir_left else 0
	var right :int= 1 if input_dir_right else 0
	
	
	var input_dir := right - left
	
	print(input_dir)
	var dir:int;
	if(input_dir<0):
		dir = -1
	elif input_dir > 0:
		dir = 1
	else:
		dir = 0
	match current_position:
		midPosition.position:
			from_midPos(dir)
		leftPosition.position:
			from_leftPos(dir)
		rightPosition.position:
			from_rightPos(dir)
		_:
			print("Nu uh")
	print(current_position)
	position = current_position + Vector3.UP * offset


func from_midPos(dir:int)->void:
	match dir:
		1:
			current_position = rightPosition.position
		-1:
			current_position = leftPosition.position
		0:
			current_position = midPosition.position
		_:
			print("Idk How that happened,Sorry")

func from_leftPos(dir:int)->void:
	match dir:
		1:
			current_position = midPosition.position
		-1:
			current_position = leftPosition.position
		0:
			current_position = leftPosition.position
		_:
			print("Idk How that happened,Sorry")

func from_rightPos(dir:int)->void:
	match dir:
		1:
			current_position = rightPosition.position
		-1:
			current_position = midPosition.position
		0:
			current_position = rightPosition.position
		_:
			print("Idk How that happened,Sorry")
	
