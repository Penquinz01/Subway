extends Node3D

enum Position{
	Left,
	Center,
	Right
}

@onready var question_timer : Timer = $"../QuesionTimer"
@onready var player : = $"../Player"
@onready var freeze_timer: Timer = $'../FreezeTimer'


var answer : bool = true
@export var no_of_questions := 10
var score : int = 0

var is_game_ended:bool= false

@export var right_answer_score : int = 10
@export var freeze_timer_wait_time : float = 3
@export var question_timer_wait_time:float = 1

signal on_new_score(score:int)
signal update_ui_time(time:int)
signal game_ended
signal vehicle_spawn(answer_for_the_question:bool)
signal vehicle_stop

func _ready() -> void:
	update_ui_time.emit(question_timer_wait_time)
	on_new_score.emit(0)


func check_answer(pos:Position)->bool:
	print(pos)
	if pos == Position.Center:
		return false

	if (pos == Position.Right and answer == false) or (pos == Position.Left and answer == true):
		score += right_answer_score
		on_new_score.emit(score)
		print(score)
		return true
	return false


func _on_freeze_timer_timeout() -> void:
	freeze_timer.stop()
	question_timer.start(question_timer_wait_time)
	update_ui_time.emit(question_timer_wait_time)
	vehicle_stop.emit()

func _on_quesion_timer_timeout() -> void:
	player.getCurrentPos()
	question_timer.stop()
	freeze_timer.start(freeze_timer_wait_time)
	update_ui_time.emit(freeze_timer_wait_time)
	no_of_questions-= 1
	if no_of_questions<=0:
		is_game_ended = true
		game_ended.emit()
		to_leaderboard()
		print("Game Ended")
		return
	vehicle_spawn.emit(answer)

func to_leaderboard():
	#do whatever is needed here
	print("Doing leaderboard update")