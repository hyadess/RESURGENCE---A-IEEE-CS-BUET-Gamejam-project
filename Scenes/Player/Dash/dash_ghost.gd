extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween=create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"modulate:a",0,1.0).from(0.7)
	tween.tween_callback(queue_free).set_delay(2)
	



#not fully sure..but working..............

#func _on_finished():
	#queue_free()
	



