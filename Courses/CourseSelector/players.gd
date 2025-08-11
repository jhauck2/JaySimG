extends VBoxContainer

var num_players = 1

signal send_players(players)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_player():
	if num_players < 4:
		num_players += 1
		var new_line = LineEdit.new()
		new_line.set("theme_override_font_sizes/font_size", 30)
		new_line.text = "Player " + str(num_players)
		add_child(new_line)
		


func remove_player():
	if num_players > 1:
		var last_player = get_child(num_players)
		last_player.queue_free()
		num_players -= 1


func _on_play_button_pressed() -> void:
	var players := []
	for child in get_children():
		if child is LineEdit:
			players.append(child.text)
			
	emit_signal("send_players", players)
