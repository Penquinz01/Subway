extends Node3D

enum Position{
	Left,
	Center,
	Right
}

@onready var question_timer : Timer = $"../QuesionTimer"
@onready var player : = $"../Player"
@onready var freeze_timer: Timer = $'../FreezeTimer'

var questions := []

@export var no_of_questions :int = 10
var score : int = 0

var currentQuestion:= 0

var is_game_ended:bool= false
var is_game_started:bool = false

@export var right_answer_score : int = 10
@export var freeze_timer_wait_time : float = 3
@export var question_timer_wait_time:float = 1

var target_date_dict = {
		"year": 2026,
		"month": 4,
		"day": 2,
		"hour": 0,
		"minute": 0,
		"second": 0
	}

signal on_new_score(score:int)
signal update_ui_time(time:int)
signal game_ended
signal vehicle_spawn(answer_for_the_question:bool)
signal vehicle_stop
signal next_questions(question:String)
signal question_ended
signal question_started

func _ready() -> void:
	update_ui_time.emit(question_timer_wait_time)
	on_new_score.emit(0)
	var days_left:int = calculate_days_difference()
	print("Days left: ", days_left)
	questions = FileLoader.load_file(days_left+1)
	questions.shuffle()
	print(questions)
	no_of_questions = min(no_of_questions, questions.size())
	next_questions.emit(questions[currentQuestion]["question"])


func check_answer(pos:Position)->bool:
	if is_game_ended or not is_game_started:
		return false
	print(pos)
	if pos == Position.Center:
		return false
	print(currentQuestion)
	print(questions[currentQuestion]["question"] + ":" + str(questions[currentQuestion]["is_truth"]))

	if (pos == Position.Right and questions[currentQuestion]["is_truth"] == false) or (pos == Position.Left and questions[currentQuestion]["is_truth"] == true):
		score += right_answer_score
		on_new_score.emit(score)
		print(score)
		return true
	return false


func _on_freeze_timer_timeout() -> void:
	if is_game_ended or not is_game_started:
		return
	freeze_timer.stop()
	question_timer.start(question_timer_wait_time)
	update_ui_time.emit(question_timer_wait_time)
	next_questions.emit(questions[currentQuestion]["question"])
	vehicle_stop.emit()
	question_started.emit()

func _on_quesion_timer_timeout() -> void:
	if is_game_ended or not is_game_started:
		return
	vehicle_spawn.emit(questions[currentQuestion]["is_truth"])
	player.getCurrentPos()
	print(currentQuestion)
	currentQuestion+=1
	question_ended.emit()
	question_timer.stop()
	if not is_game_ended:
		freeze_timer.start(freeze_timer_wait_time)
	no_of_questions-= 1

	if no_of_questions<=0:
		is_game_ended = true
		game_ended.emit()
		game_over()
		print("Game Ended")
		return

func game_over():
	#do whatever is needed here
	print("Doing leaderboard update")
	JavaScriptBridge.eval("window.parent.updateScore(" + str(score) + ")")

func game_start():
	question_timer.start(question_timer_wait_time)
	update_ui_time.emit(question_timer_wait_time)
	is_game_started = true



func calculate_days_difference() -> int:
	# 1. Get current time in seconds
	var today_seconds = Time.get_unix_time_from_system()


	var target_seconds = Time.get_unix_time_from_datetime_dict(target_date_dict)

	# 3. Subtract to get total seconds difference
	var diff_seconds =today_seconds- target_seconds 
	
	# 4. Convert seconds to days
	# (60 seconds * 60 minutes * 24 hours = 86400)
	var days_left = diff_seconds / 86400
	
	print("Days remaining: ", int(days_left))
	return int(days_left)
