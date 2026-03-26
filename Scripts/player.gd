extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var leftPosition:Node3D
@export var midPosition:Node3D
@export var rightPosition:Node3D
@export var offset:float
@onready var animPlayer:= $Casual_Hoodie/AnimationPlayer
@onready var game_manager: Node = $"../GameManager"
var current_position:Vector3
var canMove:bool = true
var is_game_ended:bool = false
var is_started:bool = false


var dir:int

func _ready() -> void:
	current_position = midPosition.position
	position = current_position
	animPlayer.play("CharacterArmature|Run")


func _physics_process(delta: float) -> void:
	if !canMove or is_game_ended or is_started == false:
		return
	move();
	
func move()->void:
	var input_dir_left := Input.is_action_just_pressed("Left");
	var input_dir_right := Input.is_action_just_pressed("Right");
	
	var left:int=1 if input_dir_left else 0
	var right :int= 1 if input_dir_right else 0
	
	
	var input_dir := right - left
	
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
	position = current_position + Vector3.UP * offset

#region NextPositionThings
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
#endregion


func resetPos()-> void :
	current_position = midPosition.position
	position = current_position

func getCurrentPos()->void:
	match current_position:
		leftPosition.position:
			game_manager.check_answer(game_manager.Position.Left)
		rightPosition.position:
			game_manager.check_answer(game_manager.Position.Right)
		midPosition.position:
			game_manager.check_answer(game_manager.Position.Center)


func _on_freeze_timer_timeout() -> void:
	canMove = true
	resetPos()


func _on_quesion_timer_timeout() -> void:
	canMove = false
	dir = 0


func _on_ui_leftclicked() -> void:
	dir = -1

func _on_ui_rightclicked() -> void:
	dir = 1

func _on_game_ended()->void:
	canMove = false
	is_game_ended = true

func _on_game_started()->void:
	is_started = true