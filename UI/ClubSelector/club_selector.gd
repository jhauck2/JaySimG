extends Control

var clubs := ["Dr", "3w", "Hy", "4i", "5i", "6i", "7i", "8i", "9i", "Pw", "Sw", "Lw"]
var club_index := 0

signal club_selected(club: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_left_select_pressed() -> void:
	club_index -= 1
	if club_index < 0:
		club_index = clubs.size() - 1
	
	emit_signal("club_selected", clubs[club_index])


func _on_right_select_pressed() -> void:
	club_index = (club_index + 1) % clubs.size()
	
	emit_signal("club_selected", clubs[club_index])
