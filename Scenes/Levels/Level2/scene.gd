extends Node2D

#signals
signal level_clear
signal level_lost

func _ready():
#	camera = $Player/Camera2D
#	camera.make_current()
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property($CanvasLayer/Label,"modulate:a",1.0,3).from(0.1)
	
	


func _on_timer_timeout():
	emit_signal("level_clear")
