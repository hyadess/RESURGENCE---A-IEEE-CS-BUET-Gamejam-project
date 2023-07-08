extends Control

signal resume_button
signal exit_button
signal restart_button

func _on_resume_button_pressed():
	emit_signal("resume_button")

func _on_restart_button_pressed():
	emit_signal("restart_button")

func _on_exit_button_pressed():
	emit_signal("exit_button")
