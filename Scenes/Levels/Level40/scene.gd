extends Node2D

#signals
signal level_clear
signal level_lost

func _ready():
	
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property($CanvasLayer/Label,"modulate:a",1.0,3).from(0.1)
	await get_tree().create_timer(3).timeout
	emit_signal("level_clear")
