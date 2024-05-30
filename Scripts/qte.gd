extends Node

signal qte_success
signal qte_failure

var current_step = 0
var qte_sequence = ["ui_up", "ui_down", "ui_left", "ui_right"]
var qte_timeout = 1.0
@onready var timer = $QTEtimer

func _ready():
	timer = Timer.new()
	add_child(timer)
	Signals.connect("start_qte", Callable(self, "_start_qte"))

func _start_qte():
	current_step = 0
	_show_qte_prompt()
	timer.start(qte_timeout)

func _input(event):
	if event.is_action_pressed(qte_sequence[current_step]):
		current_step += 1
		if current_step >= qte_sequence.size():
			emit_signal("qte_success")
			timer.stop()
		else:
			_show_qte_prompt()
	else:
		emit_signal("qte_failure")
		timer.stop()

func _show_qte_prompt():
	# Показываем текущий шаг QTE игроку (например, через GUI)
	pass

func _on_timeout():
	emit_signal("qte_failure")


