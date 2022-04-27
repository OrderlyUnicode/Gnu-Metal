extends Control

func _ready() -> void:
	pass #add focus code here

func _on_NewButton_pressed() -> void:
	get_tree().change_scene("res://scn/map/Maine.tscn")

func _on_QuitButton_pressed() -> void:
	get_tree().quit(0)
