extends CanvasLayer

var shield_progress_texture = {
	"green" : "res://Art/GUI/barHorizontal_green_mid 200.png",
	"yellow" : "res://Art/GUI/barHorizontal_yellow_mid 200.png",
	"red" : "res://Art/GUI/barHorizontal_red_mid 200.png"
}

func _input(event):
	if event.is_action_pressed("game_pause"):
		Global.paused = not Global.paused
		$PausedPanel.visible = Global.paused
		$Message.visible = not Global.paused
		get_tree().paused = Global.paused


func update(player):
	$Score.text = str(Global.score)
	$ShieldProgressBar.value = player.shield_health
	var color = "green"
	if $ShieldProgressBar.value < 40:
		color = "red"
	elif $ShieldProgressBar.value < 70:
		color = "yellow"
	$ShieldProgressBar.texture_progress = load(shield_progress_texture[color])


func show_message(message: String):
	$Message.text = message
	$Message.show()
	$MessageTimer.start()


func _on_MessageTimer_timeout():
	$Message.text = ""
	$Message.hide()



