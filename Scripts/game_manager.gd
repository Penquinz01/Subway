extends Node3D

enum Position{
	Left,
	Center,
	Right
}

@onready var question_timer : Timer = $"../QuesionTimer"
@onready var player : = $"../Player"
@onready var freeze_timer: Timer = $'../FreezeTimer'

var questions := [
	"State Election Commission \n conducts Assembly Elections in a State",
	"Viral video showing a\n 'resurrected' former Indian leader endorsing\n a candidate in Kerala is a deepfake.",
	"Kerala Police establish 24/7\n Social Media Monitoring Cell to curb\n communal election narratives.",
	"Leaked memo reveals Meta\n will allow political parties\n to 'force-join' users into WhatsApp groups.",
	"Senator Mark Warner urges\n major tech firms to implement AI\n watermarking before 2026 US midterms.",
	]

var answer : = [false,false,true,false,true]
@export var no_of_questions := 5
var score : int = 0

var currentQuestion:= 0

var is_game_ended:bool= false

@export var right_answer_score : int = 10
@export var freeze_timer_wait_time : float = 3
@export var question_timer_wait_time:float = 1

signal on_new_score(score:int)
signal update_ui_time(time:int)
signal game_ended
signal vehicle_spawn(answer_for_the_question:bool)
signal vehicle_stop
signal next_questions(question:String)

func _ready() -> void:
	update_ui_time.emit(question_timer_wait_time)
	on_new_score.emit(0)
	next_questions.emit(questions[currentQuestion])


func check_answer(pos:Position)->bool:
	if is_game_ended:
		return false
	print(pos)
	if pos == Position.Center:
		return false
	print(currentQuestion)
	print(questions[currentQuestion] + ":" + str(answer[currentQuestion]))

	if (pos == Position.Right and answer[currentQuestion] == false) or (pos == Position.Left and answer[currentQuestion] == true):
		score += right_answer_score
		on_new_score.emit(score)
		print(score)
		return true
	return false


func _on_freeze_timer_timeout() -> void:
	if is_game_ended:
		return
	freeze_timer.stop()
	question_timer.start(question_timer_wait_time)
	update_ui_time.emit(question_timer_wait_time)
	next_questions.emit(questions[currentQuestion])
	vehicle_stop.emit()

func _on_quesion_timer_timeout() -> void:
	if is_game_ended:
		return
	vehicle_spawn.emit(answer[currentQuestion])
	player.getCurrentPos()
	print(currentQuestion)
	currentQuestion+=1
	question_timer.stop()
	if not is_game_ended:
		freeze_timer.start(freeze_timer_wait_time)
		update_ui_time.emit(freeze_timer_wait_time)
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
