extends Control


func _ready() -> void:
	$VBoxContainer/ResolutionButton.add_item("2560x1440")
	$VBoxContainer/ResolutionButton.add_item("1920x1080")
	$VBoxContainer/ResolutionButton.add_item("1280x720")
	$VBoxContainer/ResolutionButton.add_item("854x480")



func _on_FullscreenButton_pressed() -> void:
	OS.window_fullscreen = not OS.window_fullscreen
	$VBoxContainer/FullscreenButton.set_text("Fullscreen: On") if OS.window_fullscreen else $VBoxContainer/FullscreenButton.set_text("Fullscreen: Off")
	#$VBoxContainer/FullscreenButton.text = "Fullscreen: On" if fullscreen == true else $VBoxContainer/FullscreenButton.text = "Fullscreen: Off"

func _on_ResolutionButton_item_selected(index: int) -> void:
	if index == 0:
		OS.window_size = Vector2(2560, 1440)
	elif index == 1:
		OS.window_size = Vector2(1920, 1080)
	elif index == 2:
		OS.window_size = Vector2(1280, 720)
	elif index == 3:
		OS.window_size = Vector2(854, 480)

func _on_ApplyButton_pressed() -> void:
	pass # Replace with function body.

func _on_BackButton_pressed() -> void:
	get_tree().change_scene("res://scn/UI/MainMenu.tscn")
