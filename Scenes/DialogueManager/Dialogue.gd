extends Label

func _ready() -> void:
	self.text = ""
	
func show_dialogue(text:String):
	self.text = text
#	$Tween.interpolate_property(
#		self, "percent_visible",
#		0.0, 1.0, text.length()/15.0, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR
#	)
#	$Tween.start()
