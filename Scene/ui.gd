extends Control

@onready var end_screen: Label = $"End Screen"
@onready var ui_timer: Timer =$OnGame/UITimer
@onready var time_label: Label = $OnGame/Time
@onready var score_label: Label = $OnGame/Score
@onready var on_game: Node = $OnGame

signal leftclicked
signal rightclicked

var current_score :int = 0

func _ready() -> void:

	ui_timer.start(10)
	score_label.text = "Score : 0"
	GameManager.on_new_score.connect(_on_game_manager_on_new_score)
	end_screen.set_process(false)
	end_screen.hide()


func _process(delta: float) -> void:
	var time_left := ui_timer.time_left
	time_label.text = str(int(time_left))


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
