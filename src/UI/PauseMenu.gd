extends Control

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		pauseToggle()


func pauseToggle() -> void:
	visible = not visible
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) if visible == false else Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = not get_tree().paused


func _on_ResumeButton_pressed() -> void:
	pauseToggle()

func _on_QuitButton_pressed() -> void:
	get_tree().change_scene("res://scn/UI/MainMenu.tscn")


func _on_OptionsButton_pressed() -> void:
	pass # Replace with function body.
