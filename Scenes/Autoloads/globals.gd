extends Node2D

const SAVE_FILE = "res://gamedata.txt"

var level_to_load:int = 3
var max_level_reached:int = 0
@export var total_levels:int = 11
var level_lost = false
var showing_dialogue = false
var got_key = false

func _ready() -> void:
	load_data()
#
func level_complete(level_no:int):
	if level_no >= max_level_reached:
		max_level_reached = min(total_levels, level_no+1)
	#save_data()
#
func has_next_level():
	if level_to_load + 1 > total_levels: return false
	return true
#
func set_next_level():
	level_to_load += 1 
	
func load_data():
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	var data = file.get_as_text()
	level_to_load = int(data)

func save_data():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_line(str(level_to_load))

