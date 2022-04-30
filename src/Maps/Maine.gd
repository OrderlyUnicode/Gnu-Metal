extends Spatial

onready var enemy = preload("res://scn/Actors/Enemy.tscn")
onready var box = preload("res://scn/map/Prop.tscn")
var first: bool = true

func _ready() -> void:
	$WaveTimer.start()
	$LevelTimer.start()

func _on_WaveTimer_timeout() -> void:
	var boxes: int = 3
	var enemies: int = 5
	if not first:
		boxes += randi() % 3
		enemies *= randi() % 3
	
	for j in boxes:
		var boxSpawn = box.instance()
		boxSpawn.pickup = true
		var boxType = randi() % 3 + 1
		add_child(boxSpawn)
		match(boxType):
			1:
				boxSpawn.propType = 1
			2:
				boxSpawn.propType = 2
			3:
				boxSpawn.propType = 3
			
		boxSpawn.translation = Vector3(rand_range(-20, 20), 0.2, rand_range(-20, 20))
	
	for i in enemies:
		var enemySpawn = enemy.instance()
		add_child(enemySpawn)
		print("enemy spawned")
		enemySpawn.translation = Vector3(rand_range(-10, 10), 0.2, rand_range(-10, 10))
	first = false

func _on_LevelTimer_timeout() -> void:
	get_tree().change_scene("res://scn/UI/WinScreen.tscn")
