extends Control


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_ReplayButton_pressed() -> void:
	get_tree().change_scene("res://scn/map/Maine.tscn")

func _on_QuitButton_pressed() -> void:
	get_tree().change_scene("res://scn/UI/MainMenu.tscn")
