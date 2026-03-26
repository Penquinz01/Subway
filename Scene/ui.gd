extends Control

@onready var end_screen: Label = $"End Screen"
@onready var ui_timer: Timer =$OnGame/UITimer
@onready var time_label: Label = $OnGame/Time
@onready var score_label: Label = $OnGame/Score
@onready var on_game: Node = $OnGame
@onready var question_label : Label = $OnGame/Question
@onready var start_page: Control = $"Start Page"
signal leftclicked
signal rightclicked
signal startclicked

var current_score :int = 0

func _ready() -> void:
	on_game.hide()
	ui_timer.start(15)
	score_label.text = "Score : 0"
	end_screen.set_process(false)
	end_screen.hide()
	

func _process(delta: float) -> void:
	var time_left := ui_timer.time_left
	time_label.text = str(int(time_left+1))


func change_timer(time:int):
	if ui_timer == null:
		return
	ui_timer.start(time)


func _on_left_pressed() -> void:
	leftclicked.emit()


func _on_right_pressed() -> void:
	rightclicked.emit()


func _on_game_manager_on_new_score(score: int) -> void:
	print("Score change called")
	if score_label == null:
		return
	current_score = score
	score_label.text = "Score : " + str(score)

func _on_game_ended() -> void:
	end_screen.set_process(true)
	end_screen.show()
	on_game.set_process(false)
	on_game.hide()
	end_screen.text = "Game Over\nYour Score is " + str(current_score)
	print("Game Ended")

func _on_question_next(question:String):
	question_label.text = question

func _on_start_pressed() -> void:
	start_page.hide()
	on_game.show()
	startclicked.emit()

func hide_timer() -> void:
	ui_timer.stop()
	time_label.hide()

func show_timer() -> void:
	time_label.show()
